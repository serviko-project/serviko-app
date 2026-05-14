import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';

class StatusUtils {
  static Color getBookingStatusColor(String status) {
    final bookingStatus = BookingStatus.fromString(status);
    return switch (bookingStatus) {
      BookingStatus.pending => AppColors.warning,
      BookingStatus.confirmed => AppColors.success,
      BookingStatus.rejected => AppColors.error,
      BookingStatus.cancelled => AppColors.error.withValues(alpha: 0.7),
      BookingStatus.completed => AppColors.success,
      BookingStatus.expired => AppColors.error.withValues(alpha: 0.7),
    };
  }

  static String getBookingStatusText(String status) {
    final bookingStatus = BookingStatus.fromString(status);
    return switch (bookingStatus) {
      BookingStatus.pending => 'Pending Request',
      BookingStatus.confirmed => 'Confirmed',
      BookingStatus.rejected => 'Rejected',
      BookingStatus.cancelled => 'Cancelled',
      BookingStatus.completed => 'Completed',
      BookingStatus.expired => 'Expired',
    };
  }
}
