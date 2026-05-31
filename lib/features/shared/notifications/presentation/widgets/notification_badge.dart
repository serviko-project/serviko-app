import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/features/shared/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:serviko_app/features/shared/notifications/presentation/cubit/notifications_state.dart';

class NotificationBadge extends StatelessWidget {
  final Color iconColor;
  final double iconSize;

  const NotificationBadge({
    super.key,
    this.iconColor = AppColors.textPrimary,
    this.iconSize = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        int unreadCount = 0;
        if (state is NotificationsLoaded) {
          unreadCount = state.unreadCount;
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () => context.pushNamed(RouteNames.notifications),
              icon: Icon(CupertinoIcons.bell, color: iconColor, size: iconSize),
            ),
            if (unreadCount > 0)
              Positioned(
                right: AppSizes.sm,
                top: AppSizes.sm,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: AppSizes.md,
                    minHeight: AppSizes.md,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
