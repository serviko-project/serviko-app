import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class GetProviderReviewsStatsUseCase
    implements UseCase<Map<String, dynamic>, String> {
  final BookingRepository repository;

  GetProviderReviewsStatsUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String providerId) {
    return repository.getProviderReviewStats(providerId: providerId);
  }
}
