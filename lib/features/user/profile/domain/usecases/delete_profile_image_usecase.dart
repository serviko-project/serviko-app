import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/user/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/user/profile/domain/repositories/profile_repository.dart';

// Delete profile image use case
class DeleteProfileImageUseCase {
  final UserProfileRepository _repository;

  DeleteProfileImageUseCase(this._repository);

  Future<Either<Failure, UserProfileEntity>> call() {
    return _repository.deleteProfileImage();
  }
}
