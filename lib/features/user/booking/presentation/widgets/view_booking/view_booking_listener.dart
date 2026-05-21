import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/view_booking_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/view_booking_state.dart';
import 'package:serviko_app/features/user/payment/presentation/cubit/payment_cubit.dart';
import 'package:serviko_app/features/user/payment/presentation/cubit/payment_state.dart';
import 'package:serviko_app/features/user/payment/presentation/helpers/razorpay_payment_handler.dart';

// View Booking Listener : Handles Payment and Booking Action Feedback
class ViewBookingListener extends StatefulWidget {
  final Widget child;

  const ViewBookingListener({super.key, required this.child});

  @override
  State<ViewBookingListener> createState() => _ViewBookingListenerState();
}

class _ViewBookingListenerState extends State<ViewBookingListener> {
  late final RazorpayPaymentHandler _paymentHandler;

  @override
  void initState() {
    super.initState();
    _paymentHandler = RazorpayPaymentHandler(
      onSuccess: _handlePaymentSuccess,
      onError: _handlePaymentError,
      onExternalWallet: _handleExternalWallet,
    );
  }

  @override
  void dispose() {
    _paymentHandler.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final booking = context.read<ViewBookingCubit>().state.booking;
    if (booking == null ||
        response.orderId == null ||
        response.paymentId == null ||
        response.signature == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment response was incomplete')),
      );
      return;
    }

    context.read<PaymentCubit>().verify(
      bookingId: booking.id,
      razorpayOrderId: response.orderId!,
      razorpayPaymentId: response.paymentId!,
      razorpaySignature: response.signature!,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    String errorMessage = 'Payment was cancelled or failed';

    if (response.code == 2) {
      errorMessage = 'Payment was cancelled';
    } else if (response.message != null &&
        response.message!.trim().isNotEmpty &&
        response.message!.toLowerCase() != 'undefined') {
      errorMessage = response.message!;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName ?? ''}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ViewBookingCubit, ViewBookingState>(
          listenWhen: (previous, current) =>
              previous.actionStatus != current.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == ViewBookingActionStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Success'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state.actionStatus == ViewBookingActionStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'An error occurred'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
        BlocListener<PaymentCubit, PaymentState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == PaymentFlowStatus.orderCreated &&
                state.order != null) {
              _paymentHandler.openCheckout(state.order!);
            } else if (state.status == PaymentFlowStatus.verified) {
              final bookingId = state.payment?.bookingId;
              if (bookingId != null) {
                context.read<ViewBookingCubit>().fetchBookingDetails(bookingId);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Payment successful'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state.status == PaymentFlowStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Payment failed'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
