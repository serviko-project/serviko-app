import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/features/shared/notifications/domain/entities/notification_entity.dart';
import 'package:serviko_app/features/shared/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:serviko_app/features/shared/notifications/presentation/utils/notification_ui_utils.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: () {
        context.read<NotificationsCubit>().markAsRead(notification.id);

        // Navigate based on type
        final bookingId = notification.data?['booking_id'] as String?;
        if (bookingId != null) {
          context.pushNamed(
            RouteNames.viewBooking,
            pathParameters: {'id': bookingId},
          );
        }
      },
      child: Container(
        color: isUnread
            ? AppColors.primary.withValues(alpha: 0.04)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: 12.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: NotificationUiUtils.getIconBackgroundColor(
                  context,
                  notification.type,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                NotificationUiUtils.getIconData(notification.type),
                color: NotificationUiUtils.getIconColor(
                  context,
                  notification.type,
                ),
                size: 22.0,
              ),
            ),
            const SizedBox(width: AppSizes.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    notification.body,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    DateTimeUtils.formatToRelativeTime(notification.createdAt),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),

            // Unread Dot
            if (isUnread)
              Container(
                margin: const EdgeInsets.only(
                  top: AppSizes.xs,
                  left: AppSizes.sm,
                ),
                width: AppSizes.sm,
                height: AppSizes.sm,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
