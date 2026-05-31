import 'dart:async';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_service.dart';
import 'package:serviko_app/features/shared/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:serviko_app/injection_container.dart';

abstract final class NotificationNavigationHandler {
  // Initialize FCM configuration
  static void setupPushNotifications(NotificationsCubit cubit) {
    final fcmService = InjectionContainer.instance.pushNotificationService;
    unawaited(
      fcmService.initialize(
        onTokenRetrieved: (token) async {
          await cubit.registerDeviceToken(token);
        },
        onMessageReceived: (message) {
          cubit.fetchNotifications();
        },
        onNotificationTapped: (data) {
          handleNotificationTap(jsonEncode(data));
        },
      ),
    );
  }

  // Process and route notification tap
  static void handleNotificationTap(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final bookingId = data['booking_id'] as String?;
      if (bookingId != null) {
        final context = ZegoService.navigatorKey.currentContext;
        if (context != null && context.mounted) {
          context.push(RoutePaths.viewBooking.replaceAll(':id', bookingId));
        }
      }
    } catch (_) {}
  }
}
