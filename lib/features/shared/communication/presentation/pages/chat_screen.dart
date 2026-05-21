import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/injection_container.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.contact,
    required this.customerFirebaseUid,
    this.conversationType = ZIMConversationType.peer,
  });

  final ProviderDirectoryEntity contact;
  final String customerFirebaseUid;
  final ZIMConversationType conversationType;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Method to start a call (audio or video)
  Future<void> _startCall(bool isVideoCall) async {
    final sent = await InjectionContainer.instance.zegoService.startCall(
      contact: widget.contact,
      isVideoCall: isVideoCall,
      customerFirebaseUid: widget.customerFirebaseUid,
    );
    if (!mounted || sent) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Could not start the call.')));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: AppColors.primary),
      child: ZIMKitMessageListPage(
        conversationID: widget.contact.firebaseUid,
        conversationType: widget.conversationType,
        showMoreButton: false,
        preMessageSending: _trimTextMessage,
        messageInputContainerPadding: const EdgeInsets.all(AppSizes.sm),
        messageInputContainerDecoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        inputBackgroundDecoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        inputDecoration: const InputDecoration(
          hintText: 'Message',
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: 12,
          ),
        ),
        sendButtonWidget: const Padding(
          padding: EdgeInsets.only(left: 6, right: 2),
          child: Icon(
            Icons.send_rounded,
            color: AppColors.primary,
            size: AppSizes.lg,
          ),
        ),

        appBarBuilder: (context, defaultAppBar) {
          return AppBar(
            titleSpacing: 0,
            leading: const BackButtonWidget(),
            title: Row(
              spacing: AppSizes.sm,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.contact.profileImageUrl != null
                      ? NetworkImage(widget.contact.profileImageUrl!)
                      : null,
                  child: widget.contact.profileImageUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                // Name and Category
                Expanded(
                  child: Column(
                    spacing: AppSizes.xs / 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.contact.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h3,
                      ),
                      Text(
                        widget.contact.categorySummary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Audio Call Button
              IconButton(
                tooltip: 'Audio call',
                onPressed: () => _startCall(false),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCall02,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              // Video Call Button
              IconButton(
                tooltip: 'Video call',
                onPressed: () => _startCall(true),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedVideo01,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ZIMKitMessage _trimTextMessage(ZIMKitMessage message) {
    final textContent = message.textContent;
    if (textContent == null) return message;

    textContent.text = textContent.text.trim();
    return message;
  }
}
