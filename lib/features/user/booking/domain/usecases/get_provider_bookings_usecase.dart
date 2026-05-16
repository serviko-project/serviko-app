import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetProviderBookingsUseCase
    implements UseCase<List<BookingEntity>, GetProviderBookingsParams> {
  final BookingRepository repository;

  GetProviderBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(
    GetProviderBookingsParams params,
  ) async {
    return await repository.getProviderBookings(
      status: params.status,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetProviderBookingsParams extends Equatable {
  final String? status;
  final int page;
  final int limit;

  const GetProviderBookingsParams({
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [status, page, limit];
}
