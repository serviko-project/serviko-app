import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class ReviewBookingUseCase
    implements UseCase<BookingEntity, ReviewBookingParams> {
  final BookingRepository repository;

  ReviewBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(
    ReviewBookingParams params,
  ) async {
    return await repository.reviewBooking(
      bookingId: params.bookingId,
      action: params.action,
      rejectionReason: params.rejectionReason,
    );
  }
}

class ReviewBookingParams extends Equatable {
  final String bookingId;
  final String action;
  final String? rejectionReason;

  const ReviewBookingParams({
    required this.bookingId,
    required this.action,
    this.rejectionReason,
  });

  @override
  List<Object?> get props => [bookingId, action, rejectionReason];
}
