import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/profile_menu_tile.dart';

class PolicyAndHelpCardWidget extends StatelessWidget {
  const PolicyAndHelpCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: const Column(
        children: [
          ProfileMenuTile(
            title: 'Privacy Policy',
            icon: HugeIcons.strokeRoundedShield01,
            onTap: null,
          ),
          ProfileMenuDivider(),
          ProfileMenuTile(
            title: 'Help Center',
            icon: HugeIcons.strokeRoundedInformationCircle,
            onTap: null,
          ),
        ],
      ),
    );
  }
}
