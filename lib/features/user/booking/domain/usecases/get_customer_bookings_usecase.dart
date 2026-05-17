import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetCustomerBookingsUseCase
    implements UseCase<List<BookingEntity>, GetCustomerBookingsParams> {
  final BookingRepository repository;

  GetCustomerBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(
    GetCustomerBookingsParams params,
  ) async {
    return await repository.getCustomerBookings(
      status: params.status,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCustomerBookingsParams extends Equatable {
  final String? status;
  final int page;
  final int limit;

  const GetCustomerBookingsParams({
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [status, page, limit];
}
