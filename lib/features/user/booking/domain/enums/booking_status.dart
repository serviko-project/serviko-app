import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';

enum BookingStatus {
  pending('pending'),
  confirmed('confirmed'),
  completed('completed'),
  rejected('rejected'),
  cancelled('cancelled'),
  expired('expired');

  final String value;
  const BookingStatus(this.value);

  static BookingStatus fromString(String status) {
    return BookingStatus.values.firstWhere(
      (e) => e.value == status.toLowerCase(),
      orElse: () => BookingStatus.pending,
    );
  }

  // Status color for banners and tags
  Color get color => switch (this) {
    pending => AppColors.warning,
    confirmed => AppColors.info,
    completed => AppColors.success,
    rejected => AppColors.error,
    cancelled => AppColors.error,
    expired => AppColors.textSecondary,
  };

  // Status icon for banners and tags
  IconData get icon => switch (this) {
    pending => Icons.hourglass_empty_rounded,
    confirmed => Icons.check_circle_outline_rounded,
    completed => Icons.verified_rounded,
    rejected => Icons.cancel_outlined,
    cancelled => Icons.remove_circle_outline_rounded,
    expired => Icons.timer_off_outlined,
  };

  // Short label
  String get displayLabel => switch (this) {
    pending => 'Pending',
    confirmed => 'Upcoming',
    completed => 'Completed',
    rejected => 'Rejected',
    cancelled => 'Cancelled',
    expired => 'Expired',
  };

  // Full banner text for detail screens
  String get bannerText => switch (this) {
    pending => 'Waiting for Provider Approval',
    confirmed => 'Booking Confirmed',
    completed => 'Service Completed Successfully',
    rejected => 'Booking Rejected by Provider',
    cancelled => 'Booking Cancelled',
    expired => 'Booking Request Expired',
  };
}
