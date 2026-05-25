import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';
import '../../domain/entities/provider_dashboard_stats_entity.dart';
import '../../domain/repositories/provider_dashboard_repository.dart';
import '../datasources/provider_dashboard_remote_datasource.dart';

class ProviderDashboardRepositoryImpl implements ProviderDashboardRepository {
  final ProviderDashboardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProviderDashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProviderDashboardStatsEntity>>
  getDashboardStats() async {
    try {
      final stats = await remoteDataSource.getDashboardStats();
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
