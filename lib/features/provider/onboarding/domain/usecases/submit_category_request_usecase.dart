import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

class SubmitCategoryRequestUseCase
    implements UseCase<void, SubmitCategoryRequestParams> {
  final ProviderOnboardingRepository repository;

  SubmitCategoryRequestUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitCategoryRequestParams params) {
    return repository.submitCategoryRequest(params.toJson());
  }
}

class SubmitCategoryRequestParams {
  final String title;
  final String description;
  final double proposedBasePrice;

  SubmitCategoryRequestParams({
    required this.title,
    required this.description,
    required this.proposedBasePrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'proposed_base_price': proposedBasePrice,
    };
  }
}
