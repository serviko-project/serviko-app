import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_application_usecase.dart';

// Re-submits a rejected provider application
class ReapplyUseCase
    extends UseCase<ProviderProfileEntity, SubmitApplicationParams> {
  final ProviderOnboardingRepository _repository;

  ReapplyUseCase(this._repository);

  @override
  Future<Either<Failure, ProviderProfileEntity>> call(
    SubmitApplicationParams params,
  ) {
    return _repository.reapply(params);
  }
}
