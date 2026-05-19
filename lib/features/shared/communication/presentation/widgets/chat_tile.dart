import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/presentation/utils/chat_message_formatters.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/chat_avatar.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/unread_badge.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.contact,
    required this.conversationType,
    required this.onTap,
    this.conversationNotifier,
  });

  final ProviderDirectoryEntity contact;
  final ZIMConversationType conversationType;
  final VoidCallback onTap;
  final ZIMKitConversationNotifier? conversationNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ZIMKitConversation>(
      valueListenable:
          conversationNotifier ??
          ZIMKit().getConversation(contact.firebaseUid, conversationType),
      builder: (context, conversation, _) {
        final lastMessage = conversation.lastMessage;
        final messagePreview = chatMessagePreview(lastMessage);
        final preview = messagePreview.isNotEmpty
            ? messagePreview
            : contact.professionalTitle ?? contact.categorySummary;
        final time = chatMessageTime(lastMessage);
        final unreadCount = conversation.unreadMessageCount;

        return Material(
          color: AppColors.background,
          child: InkWell(
            onTap: () {
              ZIMKit().clearUnreadCount(contact.firebaseUid, conversationType);
              onTap();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                children: [
                  // Avatar
                  ChatAvatar(imageUrl: contact.profileImageUrl),
                  const SizedBox(width: AppSizes.md),

                  // Name, Preview, Time and Unread badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          contact.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.h3.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: unreadCount > 0
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (unreadCount > 0)
                        UnreadBadge(count: unreadCount)
                      else
                        const SizedBox(height: AppSizes.lg),
                      const SizedBox(height: 6),

                      // Last message Time
                      Text(
                        time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
