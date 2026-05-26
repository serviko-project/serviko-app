import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';

import '../../../service/domain/entities/service_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_remote_datasource.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BookmarkRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> bookmarkService(String serviceId) async {
    try {
      await remoteDataSource.bookmarkService(serviceId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unbookmarkService(String serviceId) async {
    try {
      await remoteDataSource.unbookmarkService(serviceId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getBookmarks({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final remoteBookmarks = await remoteDataSource.getBookmarks(
        page: page,
        limit: limit,
      );
      return Right(remoteBookmarks);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
