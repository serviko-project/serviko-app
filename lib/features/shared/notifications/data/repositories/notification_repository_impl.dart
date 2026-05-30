import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';
import 'package:serviko_app/features/shared/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:serviko_app/features/shared/notifications/domain/entities/notification_entity.dart';
import 'package:serviko_app/features/shared/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> registerDeviceToken({
    required String fcmToken,
    required String deviceType,
  }) async {
    try {
      await remoteDataSource.registerDeviceToken(
        fcmToken: fcmToken,
        deviceType: deviceType,
      );
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
  Future<Either<Failure, void>> removeDeviceToken({
    required String fcmToken,
  }) async {
    try {
      await remoteDataSource.removeDeviceToken(fcmToken: fcmToken);
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
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required int page,
    required int limit,
  }) async {
    try {
      final remoteNotifications = await remoteDataSource.getNotifications(
        page: page,
        limit: limit,
      );
      return Right(remoteNotifications);
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
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Right(count);
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
  Future<Either<Failure, void>> markNotificationRead(
    String notificationId,
  ) async {
    try {
      await remoteDataSource.markNotificationRead(notificationId);
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
  Future<Either<Failure, void>> markAllNotificationsRead() async {
    try {
      await remoteDataSource.markAllNotificationsRead();
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
}
