import 'package:serviko_app/features/shared/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:serviko_app/features/shared/notifications/data/repositories/notification_repository_impl.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/remove_device_token_usecase.dart';
import 'package:serviko_app/core/services/local_notification_service.dart';
import 'package:serviko_app/core/services/push_notification_service.dart';
import 'package:serviko_app/injection_container.dart';

extension NotificationsDI on InjectionContainer {
  // Initialize notification dependencies
  void initNotifications() {
    notificationRemoteDataSource = NotificationRemoteDataSourceImpl(
      apiClient: apiClient,
    );
    notificationRepository = NotificationRepositoryImpl(
      remoteDataSource: notificationRemoteDataSource,
      networkInfo: networkInfo,
    );

    getNotificationsUseCase = GetNotificationsUseCase(notificationRepository);
    getUnreadCountUseCase = GetUnreadCountUseCase(notificationRepository);
    markNotificationReadUseCase = MarkNotificationReadUseCase(
      notificationRepository,
    );
    markAllNotificationsReadUseCase = MarkAllNotificationsReadUseCase(
      notificationRepository,
    );
    registerDeviceTokenUseCase = RegisterDeviceTokenUseCase(
      notificationRepository,
    );
    removeDeviceTokenUseCase = RemoveDeviceTokenUseCase(notificationRepository);

    localNotificationService = LocalNotificationService();
    pushNotificationService = PushNotificationService(localNotificationService);
  }
}
