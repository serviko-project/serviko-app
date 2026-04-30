import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

// Fetches current user's provider profile
class GetMyProviderProfileUseCase
    extends UseCase<ProviderProfileEntity, NoParams> {
  final ProviderOnboardingRepository _repository;

  GetMyProviderProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ProviderProfileEntity>> call(NoParams params) {
    return _repository.getMyProviderProfile();
  }
}
