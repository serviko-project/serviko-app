import 'package:flutter/material.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';

class StatusUtils {
  static Color getBookingStatusColor(BookingStatus status) {
    return status.color;
  }

  static String getBookingStatusText(BookingStatus status) {
    return status.displayLabel;
  }
}
