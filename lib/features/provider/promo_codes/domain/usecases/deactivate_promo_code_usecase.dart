import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/repositories/promo_code_repository.dart';

class DeactivatePromoCodeUseCase
    implements UseCase<PromoCode, DeactivatePromoCodeParams> {
  final PromoCodeRepository repository;

  const DeactivatePromoCodeUseCase(this.repository);

  @override
  Future<Either<Failure, PromoCode>> call(DeactivatePromoCodeParams params) {
    return repository.deactivatePromoCode(params.promoId);
  }
}

class DeactivatePromoCodeParams extends Equatable {
  final String promoId;

  const DeactivatePromoCodeParams({required this.promoId});

  @override
  List<Object?> get props => [promoId];
}
