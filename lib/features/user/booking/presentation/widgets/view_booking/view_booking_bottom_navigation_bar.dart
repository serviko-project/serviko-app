import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/view_booking_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/view_booking_state.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/cancel_booking_bottom_sheet.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/view_booking/review_bottom_sheet.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/view_booking/booking_action_buttons.dart';
import 'package:serviko_app/features/user/payment/presentation/cubit/payment_cubit.dart';

class ViewBookingBottomNavigationBar extends StatelessWidget {
  const ViewBookingBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewBookingCubit, ViewBookingState>(
      buildWhen: (previous, current) => previous.booking != current.booking,
      builder: (context, state) {
        final booking = state.booking;
        if (booking != null) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: BookingActionButtons(
                  booking: booking,
                  onCancel: () => _showCancelConfirmation(context, booking.id),
                  onPayment: () =>
                      context.read<PaymentCubit>().createOrder(booking.id),
                  onReview: () => ReviewBottomSheet.show(
                    context,
                    bookingId: booking.id,
                    cubit: context.read<ViewBookingCubit>(),
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showCancelConfirmation(BuildContext context, String bookingId) {
    CancelBookingBottomSheet.show(
      context,
      onConfirm: () {
        context.read<ViewBookingCubit>().cancelBooking(bookingId);
      },
    );
  }
}
