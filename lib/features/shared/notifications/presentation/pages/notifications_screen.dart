import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/shared/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:serviko_app/features/shared/notifications/presentation/cubit/notifications_state.dart';
import 'package:serviko_app/features/shared/notifications/presentation/utils/notification_header_date.dart';
import 'package:serviko_app/features/shared/notifications/presentation/widgets/notification_tile.dart';
import 'package:serviko_app/features/shared/notifications/presentation/widgets/notifications_empty_state.dart';
import 'package:serviko_app/features/shared/notifications/presentation/widgets/notification_date_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().fetchNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationsCubit>().fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoaded && state.unreadCount > 0) {
                return IconButton(
                  onPressed: () =>
                      context.read<NotificationsCubit>().markAllAsRead(),
                  tooltip: 'Mark all as read',
                  icon: const Icon(CupertinoIcons.check_mark_circled),
                  color: AppColors.primary,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<NotificationsCubit>().fetchNotifications(),
        color: AppColors.primary,
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            // Loading State
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            //  Error State
            if (state is NotificationsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () =>
                    context.read<NotificationsCubit>().fetchNotifications(),
                icon: CupertinoIcons.wifi_exclamationmark,
                isFullPage: true,
              );
            }

            // Loaded State
            if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                return const NotificationsEmptyState();
              }

              return ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount:
                    state.notifications.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= state.notifications.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.md),
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  final notification = state.notifications[index];
                  final header = NotificationHeaderDate.getDateHeader(
                    notification.createdAt,
                  );

                  final showHeader =
                      index == 0 ||
                      NotificationHeaderDate.getDateHeader(
                            state.notifications[index - 1].createdAt,
                          ) !=
                          header;

                  final showDivider =
                      index < state.notifications.length - 1 &&
                      NotificationHeaderDate.getDateHeader(
                            state.notifications[index + 1].createdAt,
                          ) ==
                          header;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showHeader) NotificationDateHeader(title: header),
                      NotificationTile(notification: notification),
                      if (showDivider)
                        const Divider(
                          height: 1,
                          thickness: 0.5,
                          color: AppColors.shimmerBase,
                        ),
                    ],
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
