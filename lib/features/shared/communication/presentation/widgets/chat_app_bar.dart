import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';

// AppBar for Chat Screen with contact's profile image, name and call action buttons
AppBar buildChatAppBar({
  required BuildContext context,
  required ProviderDirectoryEntity contact,
  required VoidCallback onAudioCallPressed,
  required VoidCallback onVideoCallPressed,
}) {
  return AppBar(
    titleSpacing: 0,
    leading: const BackButtonWidget(),
    title: Row(
      spacing: AppSizes.sm,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: contact.profileImageUrl != null
              ? NetworkImage(contact.profileImageUrl!)
              : null,
          child: contact.profileImageUrl == null
              ? const Icon(Icons.person)
              : null,
        ),
        Expanded(
          child: Column(
            spacing: AppSizes.xs / 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h3,
              ),
              Text(
                contact.categorySummary,
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
      IconButton(
        tooltip: 'Audio call',
        onPressed: onAudioCallPressed,
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedCall02,
          color: AppColors.primary,
          size: 22,
        ),
      ),
      IconButton(
        tooltip: 'Video call',
        onPressed: onVideoCallPressed,
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedVideo01,
          color: AppColors.primary,
          size: 22,
        ),
      ),
    ],
  );
}
