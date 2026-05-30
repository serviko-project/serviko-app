import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/features/shared/notifications/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<void> registerDeviceToken({
    required String fcmToken,
    required String deviceType,
  });
  Future<void> removeDeviceToken({required String fcmToken});
  Future<List<NotificationModel>> getNotifications({
    required int page,
    required int limit,
  });
  Future<int> getUnreadCount();
  Future<void> markNotificationRead(String notificationId);
  Future<void> markAllNotificationsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> registerDeviceToken({
    required String fcmToken,
    required String deviceType,
  }) async {
    return apiClient.request<void>(
      call: () => apiClient.dio.post(
        '/api/v1/devices',
        data: {'fcm_token': fcmToken, 'device_type': deviceType},
      ),
      parser: (_) {},
    );
  }

  @override
  Future<void> removeDeviceToken({required String fcmToken}) async {
    return apiClient.request<void>(
      call: () => apiClient.dio.delete(
        '/api/v1/devices',
        data: {'fcm_token': fcmToken},
      ),
      parser: (_) {},
    );
  }

  @override
  Future<List<NotificationModel>> getNotifications({
    required int page,
    required int limit,
  }) async {
    return apiClient.request<List<NotificationModel>>(
      call: () => apiClient.dio.get(
        '/api/v1/notifications',
        queryParameters: {'page': page, 'limit': limit},
      ),
      parser: (data) {
        final List<dynamic> list = data;
        return list.map((json) {
          return NotificationModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  @override
  Future<int> getUnreadCount() async {
    return apiClient.request<int>(
      call: () => apiClient.dio.get('/api/v1/notifications/unread-count'),
      parser: (data) {
        final map = data as Map<String, dynamic>;
        return map['count'] as int;
      },
    );
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    return apiClient.request<void>(
      call: () =>
          apiClient.dio.patch('/api/v1/notifications/$notificationId/read'),
      parser: (_) {},
    );
  }

  @override
  Future<void> markAllNotificationsRead() async {
    return apiClient.request<void>(
      call: () => apiClient.dio.patch('/api/v1/notifications/read-all'),
      parser: (_) {},
    );
  }
}
