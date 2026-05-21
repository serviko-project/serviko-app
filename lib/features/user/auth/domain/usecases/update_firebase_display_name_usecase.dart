import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/auth/domain/repositories/auth_repository.dart';

class UpdateFirebaseDisplayNameUseCase extends UseCase<void, String> {
  final AuthRepository repository;

  UpdateFirebaseDisplayNameUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.updateFirebaseDisplayName(displayName: params);
  }
}
