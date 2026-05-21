import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import '../entities/payment_entity.dart';
import '../entities/payment_order_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentOrderEntity>> createBookingPaymentOrder({
    required String bookingId,
  });

  Future<Either<Failure, PaymentEntity>> verifyPayment({
    required String bookingId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  });
}
