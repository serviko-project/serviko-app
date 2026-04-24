import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';
import 'package:serviko_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:serviko_app/features/profile/data/models/profile_model.dart';
import 'package:serviko_app/features/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:serviko_app/features/profile/domain/usecases/create_profile_usecase.dart';
import 'package:serviko_app/features/profile/domain/usecases/update_profile_usecase.dart';

// Profile repository implementation
class UserUserProfileRepositoryImpl implements UserProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  UserUserProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserProfileEntity>> createProfile(
    CreateProfileParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final data = UserProfileModel.toCreateJson(
        fullName: params.fullName,
        phoneNumber: params.phoneNumber,
        dateOfBirth: params.dateOfBirth,
        gender: params.gender,
        profileImageUrl: params.profileImageUrl,
      );
      final profile = await _remoteDataSource.createProfile(data);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getMyProfile() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profile = await _remoteDataSource.getMyProfile();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final data = UserProfileModel.toUpdateJson(
        fullName: params.fullName,
        phoneNumber: params.phoneNumber,
        dateOfBirth: params.dateOfBirth,
        gender: params.gender,
        profileImageUrl: params.profileImageUrl,
      );
      final profile = await _remoteDataSource.updateProfile(data);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
