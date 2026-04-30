import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/logout_dialog.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/profile_menu_tile.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withAlpha(77), width: 1),
      ),
      child: ProfileMenuTile(
        title: 'Logout',
        icon: HugeIcons.strokeRoundedLogout03,
        isLogout: true,
        showTrailing: false,
        onTap: () => LogoutDialog.show(context),
      ),
    );
  }
}
