import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/repositories/promo_code_repository.dart';

class UpdatePromoCodeUseCase
    implements UseCase<PromoCode, UpdatePromoCodeParams> {
  final PromoCodeRepository repository;

  const UpdatePromoCodeUseCase(this.repository);

  @override
  Future<Either<Failure, PromoCode>> call(UpdatePromoCodeParams params) {
    return repository.updatePromoCode(params.promoId, params.data);
  }
}

class UpdatePromoCodeParams extends Equatable {
  final String promoId;
  final Map<String, dynamic> data;

  const UpdatePromoCodeParams({required this.promoId, required this.data});

  @override
  List<Object?> get props => [promoId, data];
}
