import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/category_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

// Fetches all service categories
class GetCategoriesUseCase extends UseCase<List<CategoryEntity>, NoParams> {
  final ProviderOnboardingRepository _repository;

  GetCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) {
    return _repository.getCategories();
  }
}
