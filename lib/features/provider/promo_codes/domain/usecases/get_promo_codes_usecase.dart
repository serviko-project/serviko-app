import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/repositories/promo_code_repository.dart';

class GetPromoCodesUseCase
    implements UseCase<List<PromoCode>, GetPromoCodesParams> {
  final PromoCodeRepository repository;

  const GetPromoCodesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PromoCode>>> call(GetPromoCodesParams params) {
    return repository.getPromoCodes(page: params.page, limit: params.limit);
  }
}

class GetPromoCodesParams extends Equatable {
  final int page;
  final int limit;

  const GetPromoCodesParams({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}
