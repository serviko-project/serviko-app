import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void Function(String? payload)? _onNotificationTappedCallback;

  // Initialize local notifications for Android
  Future<void> initialize({
    void Function(String? payload)? onNotificationTapped,
  }) async {
    _onNotificationTappedCallback = onNotificationTapped;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    _onNotificationTappedCallback?.call(response.payload);
  }

  // Show a local notification banner
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'serviko_channel',
          'Serviko Notifications',
          channelDescription:
              'Main notification channel for Serviko app alerts',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformDetails,
      payload: payload,
    );
  }
}
