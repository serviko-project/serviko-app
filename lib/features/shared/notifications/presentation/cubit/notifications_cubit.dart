import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/usecases/remove_device_token_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;
  final RegisterDeviceTokenUseCase registerDeviceTokenUseCase;
  final RemoveDeviceTokenUseCase removeDeviceTokenUseCase;

  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.getUnreadCountUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllNotificationsReadUseCase,
    required this.registerDeviceTokenUseCase,
    required this.removeDeviceTokenUseCase,
  }) : super(const NotificationsInitial());

  // Fetch first page of notifications and the unread count
  Future<void> fetchNotifications() async {
    emit(const NotificationsLoading());

    final listResult = await getNotificationsUseCase(
      const GetNotificationsParams(page: 1, limit: 20),
    );
    final countResult = await getUnreadCountUseCase(const NoParams());

    listResult.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (notifications) {
        countResult.fold(
          (failure) => emit(NotificationsError(message: failure.message)),
          (unreadCount) {
            emit(
              NotificationsLoaded(
                notifications: notifications,
                unreadCount: unreadCount,
                hasReachedMax: notifications.length < 20,
                page: 1,
              ),
            );
          },
        );
      },
    );
  }

  // Fetch subsequent pages of notifications
  Future<void> fetchNextPage() async {
    if (state is! NotificationsLoaded) return;
    final currentState = state as NotificationsLoaded;
    if (currentState.hasReachedMax) return;

    final nextPage = currentState.page + 1;
    final result = await getNotificationsUseCase(
      GetNotificationsParams(page: nextPage, limit: 20),
    );

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (newNotifications) {
        if (newNotifications.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            currentState.copyWith(
              notifications: List.from(currentState.notifications)
                ..addAll(newNotifications),
              page: nextPage,
              hasReachedMax: newNotifications.length < 20,
            ),
          );
        }
      },
    );
  }

  // Mark single notification as read
  Future<void> markAsRead(String id) async {
    if (state is! NotificationsLoaded) return;
    final currentState = state as NotificationsLoaded;

    final wasUnread = currentState.notifications.any(
      (n) => n.id == id && !n.isRead,
    );
    if (!wasUnread) return;

    final updatedList = currentState.notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    final newCount = (currentState.unreadCount - 1).clamp(0, 999);

    emit(
      currentState.copyWith(notifications: updatedList, unreadCount: newCount),
    );

    final result = await markNotificationReadUseCase(id);
    result.fold((failure) {
      emit(currentState);
    }, (_) => null);
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (state is! NotificationsLoaded) return;
    final currentState = state as NotificationsLoaded;

    if (currentState.unreadCount == 0) return;

    final updatedList = currentState.notifications.map((n) {
      return n.copyWith(isRead: true);
    }).toList();

    emit(currentState.copyWith(notifications: updatedList, unreadCount: 0));

    final result = await markAllNotificationsReadUseCase(const NoParams());
    result.fold((failure) {
      emit(currentState);
    }, (_) => null);
  }

  // Register FCM token
  Future<void> registerDeviceToken(String fcmToken) async {
    await registerDeviceTokenUseCase(
      RegisterDeviceTokenParams(
        fcmToken: fcmToken,
        deviceType: Platform.isIOS ? 'ios' : 'android',
      ),
    );
  }

  // Remove device token
  Future<void> removeDeviceToken(String fcmToken) async {
    await removeDeviceTokenUseCase(fcmToken);
  }
}
