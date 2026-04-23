import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/profile/domain/repositories/profile_repository.dart';

// Gets the current user's profile use case
class GetMyProfileUseCase extends UseCase<UserProfileEntity, NoParams> {
  final UserProfileRepository _repository;

  GetMyProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(NoParams params) {
    return _repository.getMyProfile();
  }
}
