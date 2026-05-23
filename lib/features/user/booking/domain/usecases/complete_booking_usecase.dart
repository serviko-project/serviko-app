import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CompleteBookingUseCase
    implements UseCase<BookingEntity, CompleteBookingParams> {
  final BookingRepository repository;

  CompleteBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(
    CompleteBookingParams params,
  ) async {
    return await repository.completeBooking(
      bookingId: params.bookingId,
      completionNote: params.completionNote,
    );
  }
}

class CompleteBookingParams extends Equatable {
  final String bookingId;
  final String? completionNote;

  const CompleteBookingParams({required this.bookingId, this.completionNote});

  @override
  List<Object?> get props => [bookingId, completionNote];
}
