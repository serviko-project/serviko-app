import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/user/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/user/profile/domain/repositories/profile_repository.dart';

// Upload profile image use case
class UploadProfileImageUseCase {
  final UserProfileRepository _repository;

  UploadProfileImageUseCase(this._repository);

  Future<Either<Failure, UserProfileEntity>> call(File imageFile) {
    return _repository.uploadProfileImage(imageFile);
  }
}
