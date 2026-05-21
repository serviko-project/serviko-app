import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class VerifyPaymentUseCase
    implements UseCase<PaymentEntity, VerifyPaymentParams> {
  final PaymentRepository repository;

  VerifyPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(VerifyPaymentParams params) {
    return repository.verifyPayment(
      bookingId: params.bookingId,
      razorpayOrderId: params.razorpayOrderId,
      razorpayPaymentId: params.razorpayPaymentId,
      razorpaySignature: params.razorpaySignature,
    );
  }
}

class VerifyPaymentParams extends Equatable {
  final String bookingId;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  const VerifyPaymentParams({
    required this.bookingId,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  @override
  List<Object?> get props => [
    bookingId,
    razorpayOrderId,
    razorpayPaymentId,
    razorpaySignature,
  ];
}
