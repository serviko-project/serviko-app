import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/shared/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, void>> registerDeviceToken({
    required String fcmToken,
    required String deviceType,
  });
  Future<Either<Failure, void>> removeDeviceToken({required String fcmToken});
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required int page,
    required int limit,
  });
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, void>> markNotificationRead(String notificationId);
  Future<Either<Failure, void>> markAllNotificationsRead();
}
