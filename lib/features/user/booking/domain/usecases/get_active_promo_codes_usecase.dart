import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/user/booking/domain/repositories/booking_repository.dart';

class GetActivePromoCodesUseCase
    implements UseCase<List<PromoCode>, GetActivePromoCodesParams> {
  final BookingRepository repository;

  GetActivePromoCodesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PromoCode>>> call(
    GetActivePromoCodesParams params,
  ) async {
    return await repository.getActivePromoCodes(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetActivePromoCodesParams extends Equatable {
  final int page;
  final int limit;

  const GetActivePromoCodesParams({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}
