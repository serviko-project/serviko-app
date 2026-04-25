import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/user/profile/domain/repositories/profile_repository.dart';

// Creates User Profile use case
class CreateUserProfileUseCase
    extends UseCase<UserProfileEntity, CreateProfileParams> {
  final UserProfileRepository _repository;

CreateUserProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(CreateProfileParams params) {
    return _repository.createProfile(params);
  }
}

// Params for creating a profile
class CreateProfileParams extends Equatable {
  final String fullName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profileImageUrl;

  const CreateProfileParams({
    required this.fullName,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
    fullName,
    phoneNumber,
    dateOfBirth,
    gender,
    profileImageUrl,
  ];
}
