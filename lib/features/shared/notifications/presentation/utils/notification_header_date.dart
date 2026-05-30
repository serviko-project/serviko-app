import 'package:intl/intl.dart';

class NotificationHeaderDate {
  // Utility to get date header string based on the notification's createdAt
  static String getDateHeader(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(
      localDateTime.year,
      localDateTime.month,
      localDateTime.day,
    );

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMMM yyyy').format(localDateTime);
    }
  }
}
