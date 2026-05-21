import 'package:intl/intl.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

String chatMessagePreview(ZIMKitMessage? message) {
  if (message == null) return '';
  final text = message.textContent?.text.trim();
  if (text != null && text.isNotEmpty) return text;
  if (message.imageContent != null) return 'Photo';
  if (message.videoContent != null) return 'Video';
  if (message.audioContent != null) return 'Voice message';
  if (message.fileContent != null) return 'File';
  if (message.customContent != null) return 'Message';
  return 'Message';
}

String chatMessageTime(ZIMKitMessage? message) {
  if (message == null || message.info.timestamp <= 0) return '';

  final dateTime = DateTime.fromMillisecondsSinceEpoch(message.info.timestamp);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (messageDay == today) return DateFormat('hh:mm a').format(dateTime);
  if (messageDay == today.subtract(const Duration(days: 1))) {
    return 'Yesterday';
  }
  return DateFormat('MMM d, yyyy').format(dateTime);
}
