import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/shared/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool hasReachedMax;
  final int page;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
    this.hasReachedMax = false,
    this.page = 1,
  });

  @override
  List<Object?> get props => [notifications, unreadCount, hasReachedMax, page];

  NotificationsLoaded copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? hasReachedMax,
    int? page,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError({required this.message});

  @override
  List<Object?> get props => [message];
}
