import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/review_entity.dart';
import '../repositories/booking_repository.dart';

class GetProviderReviewsUseCase
    implements UseCase<List<ReviewEntity>, GetProviderReviewsParams> {
  final BookingRepository repository;

  GetProviderReviewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(
    GetProviderReviewsParams params,
  ) {
    return repository.getProviderReviews(
      providerId: params.providerId,
      rating: params.rating,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetProviderReviewsParams {
  final String providerId;
  final int? rating;
  final int page;
  final int limit;

  GetProviderReviewsParams({
    required this.providerId,
    this.rating,
    this.page = 1,
    this.limit = 20,
  });
}
