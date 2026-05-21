import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_payment_order_usecase.dart';
import '../../domain/usecases/verify_payment_usecase.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final CreatePaymentOrderUseCase createPaymentOrderUseCase;
  final VerifyPaymentUseCase verifyPaymentUseCase;

  PaymentCubit({
    required this.createPaymentOrderUseCase,
    required this.verifyPaymentUseCase,
  }) : super(const PaymentState());

  Future<void> createOrder(String bookingId) async {
    emit(const PaymentState(status: PaymentFlowStatus.creatingOrder));
    final result = await createPaymentOrderUseCase(
      CreatePaymentOrderParams(bookingId: bookingId),
    );

    result.fold(
      (failure) => emit(
        PaymentState(
          status: PaymentFlowStatus.failure,
          message: failure.message,
        ),
      ),
      (order) => emit(
        PaymentState(status: PaymentFlowStatus.orderCreated, order: order),
      ),
    );
  }

  Future<void> verify({
    required String bookingId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    emit(state.copyWith(status: PaymentFlowStatus.verifying));
    final result = await verifyPaymentUseCase(
      VerifyPaymentParams(
        bookingId: bookingId,
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PaymentFlowStatus.failure,
          message: failure.message,
        ),
      ),
      (payment) => emit(
        state.copyWith(
          status: PaymentFlowStatus.verified,
          payment: payment,
          message: 'Payment successful',
        ),
      ),
    );
  }
}
