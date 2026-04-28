import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

// Deletes an uploaded document by its ID
class DeleteDocumentUseCase extends UseCase<void, String> {
  final ProviderOnboardingRepository _repository;

  DeleteDocumentUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String documentId) {
    return _repository.deleteDocument(documentId);
  }
}
