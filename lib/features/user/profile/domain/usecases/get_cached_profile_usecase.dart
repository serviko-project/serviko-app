import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/user/profile/domain/repositories/profile_repository.dart';

class GetCachedProfileUseCase implements UseCase<UserProfileEntity?, NoParams> {
  final UserProfileRepository repository;

  GetCachedProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity?>> call(NoParams params) async {
    return await repository.getCachedProfile();
  }
}
