import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  // Formats a TimeOfDay to 12h format
  static String formatTimeOfDayTo12Hour(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat("h:mm a").format(dt);
  }

  // Formats a DateTime to MMM dd, yyyy
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Formats a string date to 'EEE, MMM d, yyyy'
  static String formatToReadableDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEE, MMM d, yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  // Formats a 24h time to 12h format
  static String formatTo12Hour(String time24h) {
    try {
      final date = DateFormat("HH:mm").parse(time24h);
      return DateFormat("h:mm a").format(date);
    } catch (e) {
      try {
        final date = DateFormat("H:mm").parse(time24h);
        return DateFormat("h:mm a").format(date);
      } catch (_) {
        return time24h;
      }
    }
  }

  // Normalizes a time string to HH:mm format
  static String formatTo24Hour(String time) {
    try {
      final date = DateFormat("HH:mm").parse(time);
      return DateFormat("HH:mm").format(date);
    } catch (e) {
      try {
        final date = DateFormat("H:mm").parse(time);
        return DateFormat("HH:mm").format(date);
      } catch (e) {
        try {
          final date = DateFormat("h:mm a").parse(time);
          return DateFormat("HH:mm").format(date);
        } catch (_) {
          return time;
        }
      }
    }
  }
}
