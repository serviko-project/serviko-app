import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingDetailUseCase
    implements UseCase<BookingEntity, GetBookingDetailParams> {
  final BookingRepository repository;

  GetBookingDetailUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(GetBookingDetailParams params) {
    return repository.getBookingDetail(bookingId: params.bookingId);
  }
}

class GetBookingDetailParams {
  final String bookingId;

  GetBookingDetailParams({required this.bookingId});
}
