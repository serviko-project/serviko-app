import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';
import 'package:serviko_app/features/provider/promo_codes/data/datasources/promo_code_remote_datasource.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/repositories/promo_code_repository.dart';

class PromoCodeRepositoryImpl implements PromoCodeRepository {
  final PromoCodeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const PromoCodeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PromoCode>>> getPromoCodes({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final promos = await remoteDataSource.getPromoCodes(
        page: page,
        limit: limit,
      );
      return Right(promos);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PromoCode>> createPromoCode(
    Map<String, dynamic> data,
  ) async {
    try {
      final promo = await remoteDataSource.createPromoCode(data);
      return Right(promo);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PromoCode>> updatePromoCode(
    String promoId,
    Map<String, dynamic> data,
  ) async {
    try {
      final promo = await remoteDataSource.updatePromoCode(promoId, data);
      return Right(promo);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PromoCode>> deactivatePromoCode(String promoId) async {
    try {
      final promo = await remoteDataSource.deactivatePromoCode(promoId);
      return Right(promo);
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
