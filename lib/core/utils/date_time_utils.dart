import 'package:intl/intl.dart';

class DateTimeUtils {
  // Formats a DateTime
  static String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
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
