import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/repositories/promo_code_repository.dart';

class CreatePromoCodeUseCase
    implements UseCase<PromoCode, CreatePromoCodeParams> {
  final PromoCodeRepository repository;

  const CreatePromoCodeUseCase(this.repository);

  @override
  Future<Either<Failure, PromoCode>> call(CreatePromoCodeParams params) {
    return repository.createPromoCode(params.data);
  }
}

class CreatePromoCodeParams extends Equatable {
  final Map<String, dynamic> data;

  const CreatePromoCodeParams(this.data);

  @override
  List<Object?> get props => [data];
}
