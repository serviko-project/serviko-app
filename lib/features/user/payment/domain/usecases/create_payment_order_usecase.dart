import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/payment_order_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentOrderUseCase
    implements UseCase<PaymentOrderEntity, CreatePaymentOrderParams> {
  final PaymentRepository repository;

  CreatePaymentOrderUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentOrderEntity>> call(
    CreatePaymentOrderParams params,
  ) {
    return repository.createBookingPaymentOrder(bookingId: params.bookingId);
  }
}

class CreatePaymentOrderParams extends Equatable {
  final String bookingId;

  const CreatePaymentOrderParams({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}
