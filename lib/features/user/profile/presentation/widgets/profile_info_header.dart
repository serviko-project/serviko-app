import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class ProfileInfoHeader extends StatelessWidget {
  final String displayName;
  final String email;
  final String? photoUrl;

  const ProfileInfoHeader({
    super.key,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar Section
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.surface,
            backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : null,
            child: (photoUrl == null || photoUrl!.isEmpty)
                ? const HugeIcon(
                    icon: HugeIcons.strokeRoundedUser03,
                    color: AppColors.textSecondary,
                    size: 40,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),

        // Info Section
        Center(
          child: Text(
            displayName,
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            email,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
