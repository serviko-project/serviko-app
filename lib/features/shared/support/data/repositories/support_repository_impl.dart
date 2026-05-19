import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';
import 'package:serviko_app/features/shared/support/data/datasources/support_remote_datasource.dart';
import 'package:serviko_app/features/shared/support/domain/entities/faq_item.dart';
import 'package:serviko_app/features/shared/support/domain/entities/privacy_policy_item.dart';
import 'package:serviko_app/features/shared/support/domain/repositories/support_repository.dart';

// Implementation of the Support Repository
class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const SupportRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FaqItem>>> getFAQs({
    String? category,
    String? search,
  }) async {
    try {
      final faqs = await remoteDataSource.getFAQs(
        category: category,
        search: search,
      );
      return Right(faqs);
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
  Future<Either<Failure, PrivacyPolicyItem>> getPrivacyPolicy() async {
    try {
      final policy = await remoteDataSource.getPrivacyPolicy();
      return Right(policy);
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
