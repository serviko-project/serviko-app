import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';
import 'package:serviko_app/features/provider/onboarding/data/datasources/provider_onboarding_remote_datasource.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/category_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_application_usecase.dart';

// Provider onboarding repository implementation
class ProviderOnboardingRepositoryImpl implements ProviderOnboardingRepository {
  final ProviderOnboardingRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ProviderOnboardingRepositoryImpl({
    required ProviderOnboardingRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ProviderProfileEntity>> submitApplication(
    SubmitApplicationParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profile = await _remoteDataSource.submitApplication(
        params.toJson(),
      );
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, ProviderProfileEntity>> getMyProviderProfile() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profile = await _remoteDataSource.getMyProviderProfile();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, ProviderDocumentEntity>> uploadDocument({
    required String documentType,
    required File file,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final document = await _remoteDataSource.uploadDocument(
        documentType: documentType,
        file: file,
      );
      return Right(document);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String documentId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deleteDocument(documentId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, ProviderProfileEntity>> reapply(
    SubmitApplicationParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profile = await _remoteDataSource.reapply(params.toJson());
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final categories = await _remoteDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, ProviderProfileEntity>> updateProviderDetails(
    Map<String, dynamic> data,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profile = await _remoteDataSource.updateProviderDetails(data);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, ProviderProfileEntity>> uploadBannerImage(
    File file,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profile = await _remoteDataSource.uploadBannerImage(file);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, ProviderProfileEntity>> deleteBannerImage() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profile = await _remoteDataSource.deleteBannerImage();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> submitCategoryRequest(
    Map<String, dynamic> data,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.submitCategoryRequest(data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
