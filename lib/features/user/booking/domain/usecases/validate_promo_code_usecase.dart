import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/booking/domain/repositories/booking_repository.dart';

class ValidatePromoCodeUseCase
    implements UseCase<Map<String, dynamic>, ValidatePromoCodeParams> {
  final BookingRepository repository;

  const ValidatePromoCodeUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    ValidatePromoCodeParams params,
  ) {
    return repository.validatePromoCode(
      code: params.code,
      serviceId: params.serviceId,
    );
  }
}

class ValidatePromoCodeParams extends Equatable {
  final String code;
  final String serviceId;

  const ValidatePromoCodeParams({required this.code, required this.serviceId});

  @override
  List<Object?> get props => [code, serviceId];
}
