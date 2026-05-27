import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
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

String formatChatDateSeparator(DateTime datetime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCompare = DateTime(datetime.year, datetime.month, datetime.day);

  if (dateToCompare == today) {
    return 'TODAY';
  } else if (dateToCompare == yesterday) {
    return 'YESTERDAY';
  } else {
    return DateFormat('dd MMM yyyy').format(datetime).toUpperCase();
  }
}

double calculateChatInputHeight(String text, double screenWidth) {
  if (text.isEmpty) return 70.0;

  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(fontSize: 16, height: 1.2),
    ),
    textDirection: TextDirection.ltr,
  );
  final textWidth = screenWidth - 180;
  textPainter.layout(maxWidth: textWidth > 0 ? textWidth : 180);
  final numLines = textPainter.computeLineMetrics().length;

  if (numLines == 2) {
    return 92.0;
  } else if (numLines >= 3) {
    return 112.0;
  }
  return 70.0;
}
