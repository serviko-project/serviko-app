import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/review_entity.dart';
import '../repositories/booking_repository.dart';

class SubmitReviewUseCase implements UseCase<ReviewEntity, SubmitReviewParams> {
  final BookingRepository repository;

  SubmitReviewUseCase(this.repository);

  @override
  Future<Either<Failure, ReviewEntity>> call(SubmitReviewParams params) {
    return repository.submitReview(
      bookingId: params.bookingId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class SubmitReviewParams {
  final String bookingId;
  final int rating;
  final String comment;

  SubmitReviewParams({
    required this.bookingId,
    required this.rating,
    required this.comment,
  });
}
