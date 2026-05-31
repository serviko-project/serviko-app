import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:serviko_app/core/services/local_notification_service.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final LocalNotificationService _localNotifications;

  Future<void> Function(String token)? _onTokenRetrieved;
  String? _latestToken;

  PushNotificationService(this._localNotifications);

  // Initialize Firebase Cloud Messaging settings
  Future<void> initialize({
    required Future<void> Function(String token) onTokenRetrieved,
    void Function(RemoteMessage message)? onMessageReceived,
    void Function(Map<String, dynamic> data)? onNotificationTapped,
  }) async {
    _onTokenRetrieved = onTokenRetrieved;

    // Request notification permissions
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Get current FCM token
    final token = await _fcm.getToken();
    if (token != null) {
      _latestToken = token;
      await _onTokenRetrieved?.call(token);
    }

    // Handle token refresh
    _fcm.onTokenRefresh.listen((newToken) async {
      _latestToken = newToken;
      await _onTokenRetrieved?.call(newToken);
    });

    // Show local notification when message is received in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotifications.showNotification(
          id: notification.hashCode,
          title: notification.title ?? '',
          body: notification.body ?? '',
          payload: jsonEncode(message.data),
        );
      }
      onMessageReceived?.call(message);
    });

    // Handle app opening from notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onNotificationTapped?.call(message.data);
    });

    // Handle initial message
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      onNotificationTapped?.call(initialMessage.data);
    }
  }

  // Get current cached token
  Future<String?> getToken() async {
    return _latestToken ?? await _fcm.getToken();
  }
}
