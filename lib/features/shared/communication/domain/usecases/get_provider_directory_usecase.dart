import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/domain/repositories/communication_repository.dart';

class GetProviderDirectoryUseCase
    implements UseCase<List<ProviderDirectoryEntity>, NoParams> {
  const GetProviderDirectoryUseCase(this._repository);

  final CommunicationRepository _repository;

  @override
  Future<Either<Failure, List<ProviderDirectoryEntity>>> call(NoParams params) {
    return _repository.getProviderDirectory();
  }
}
