import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/presentation/utils/chat_message_formatters.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatDateSeparator extends StatelessWidget {
  final DateTime datetime;

  const ChatDateSeparator({super.key, required this.datetime});

  @override
  Widget build(BuildContext context) {
    final text = formatChatDateSeparator(datetime);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.md),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildChatMessageItem(
  BuildContext context,
  ZIMKitMessage message,
  Widget defaultWidget,
  ProviderDirectoryEntity contact,
  ZIMConversationType conversationType,
) {
  final messages = ZIMKitCore.instance.db
      .messages(contact.firebaseUid, conversationType)
      .notifier
      .value;
  if (messages.isEmpty) {
    return defaultWidget;
  }

  final index = messages.indexWhere(
    (notifier) =>
        notifier.value.info.messageID == message.info.messageID ||
        notifier.value.info.localMessageID == message.info.localMessageID,
  );

  if (index == -1) {
    return defaultWidget;
  }

  final currentDatetime = DateTime.fromMillisecondsSinceEpoch(
    message.info.timestamp,
  );
  bool showDateSeparator = false;

  if (index == 0) {
    showDateSeparator = true;
  } else {
    final previousMessage = messages[index - 1].value;
    final previousDatetime = DateTime.fromMillisecondsSinceEpoch(
      previousMessage.info.timestamp,
    );
    if (currentDatetime.year != previousDatetime.year ||
        currentDatetime.month != previousDatetime.month ||
        currentDatetime.day != previousDatetime.day) {
      showDateSeparator = true;
    }
  }

  if (showDateSeparator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChatDateSeparator(datetime: currentDatetime),
        defaultWidget,
      ],
    );
  }

  return defaultWidget;
}

Widget buildChatMessageContent(
  BuildContext context,
  ZIMKitMessage message,
  Widget defaultWidget,
) {
  final timeStr = DateFormat(
    'h:mm a',
  ).format(DateTime.fromMillisecondsSinceEpoch(message.info.timestamp));

  return Flexible(
    child: Column(
      crossAxisAlignment: message.isMine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: message.isMine
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [defaultWidget],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 4,
            left: 10,
            right: 10,
            bottom: 2,
          ),
          child: Text(
            timeStr,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
