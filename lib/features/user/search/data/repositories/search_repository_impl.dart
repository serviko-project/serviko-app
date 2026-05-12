import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';
import 'package:serviko_app/features/user/search/domain/repositories/search_repository.dart';
import 'package:serviko_app/features/user/search/data/datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ServiceEntity>>> searchServices(
    String query, {
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final remoteServices = await remoteDataSource.searchServices(
        query,
        categoryId: categoryId,
        page: page,
        limit: limit,
      );
      return Right(remoteServices);
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
