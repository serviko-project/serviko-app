import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/user/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/create_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/update_profile_usecase.dart';

// User Profile repository
abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> createProfile(
    CreateProfileParams params,
  );

  Future<Either<Failure, UserProfileEntity>> getMyProfile();

  Future<Either<Failure, UserProfileEntity>> updateProfile(
    UpdateProfileParams params,
  );
}
