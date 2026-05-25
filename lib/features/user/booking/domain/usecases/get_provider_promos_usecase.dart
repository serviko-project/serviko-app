import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/user/booking/domain/repositories/booking_repository.dart';

class GetProviderPromosUseCase
    implements UseCase<List<PromoCode>, GetProviderPromosParams> {
  final BookingRepository repository;

  GetProviderPromosUseCase(this.repository);

  @override
  Future<Either<Failure, List<PromoCode>>> call(
    GetProviderPromosParams params,
  ) async {
    return await repository.getProviderPromos(providerId: params.providerId);
  }
}

class GetProviderPromosParams extends Equatable {
  final String providerId;

  const GetProviderPromosParams({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}
