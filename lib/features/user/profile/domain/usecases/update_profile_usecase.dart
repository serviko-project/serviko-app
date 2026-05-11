import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/user/profile/domain/repositories/profile_repository.dart';

// Updates the current user's profile use case
class UpdateProfileUseCase
    extends UseCase<UserProfileEntity, UpdateProfileParams> {
  final UserProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(params);
  }
}

// Params for updating a profile : All fields are optional
class UpdateProfileParams extends Equatable {
  final String? fullName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profileImageUrl;
  final double? latitude;
  final double? longitude;

  const UpdateProfileParams({
    this.fullName,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.profileImageUrl,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
    fullName,
    phoneNumber,
    dateOfBirth,
    gender,
    profileImageUrl,
    latitude,
    longitude,
  ];
}
