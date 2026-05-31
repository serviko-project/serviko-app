import 'package:flutter/cupertino.dart';
import 'package:serviko_app/core/constants/app_colors.dart';

abstract final class NotificationUiUtils {
  // Get corresponding IconData for notification type
  static IconData getIconData(String type) {
    switch (type) {
      case 'booking_new':
        return CupertinoIcons.doc_text;
      case 'booking_confirmed':
        return CupertinoIcons.check_mark_circled;
      case 'booking_rejected':
      case 'booking_cancelled':
        return CupertinoIcons.xmark_circle;
      case 'booking_completed':
        return CupertinoIcons.gift;
      case 'payment_success':
      case 'payment_received':
        return CupertinoIcons.money_dollar_circle;
      case 'payment_refunded':
        return CupertinoIcons.arrow_counterclockwise_circle;
      case 'new_review':
        return CupertinoIcons.star_circle;
      case 'provider_approved':
        return CupertinoIcons.shield_lefthalf_fill;
      case 'provider_rejected':
      case 'provider_blocked':
        return CupertinoIcons.slash_circle;
      default:
        return CupertinoIcons.bell_circle;
    }
  }

  // Get corresponding Color for notification type
  static Color getIconColor(BuildContext context, String type) {
    switch (type) {
      case 'booking_confirmed':
      case 'payment_success':
      case 'payment_received':
      case 'provider_approved':
        return AppColors.success;
      case 'booking_rejected':
      case 'booking_cancelled':
      case 'payment_refunded':
      case 'provider_rejected':
      case 'provider_blocked':
        return AppColors.error;
      case 'booking_completed':
      case 'new_review':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  // Get corresponding background Color for notification type
  static Color getIconBackgroundColor(BuildContext context, String type) {
    return getIconColor(context, type).withValues(alpha: 0.1);
  }
}
