import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CancelBookingUseCase
    implements UseCase<BookingEntity, CancelBookingParams> {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(CancelBookingParams params) {
    return repository.cancelBooking(bookingId: params.bookingId);
  }
}

class CancelBookingParams {
  final String bookingId;

  CancelBookingParams({required this.bookingId});
}
