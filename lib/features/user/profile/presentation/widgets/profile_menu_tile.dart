import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final String title;
  final List<List<dynamic>> icon;
  final VoidCallback? onTap;
  final bool isLogout;
  final bool showTrailing;

  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.isLogout = false,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            HugeIcon(
              icon: icon,
              color: isLogout ? AppColors.error : AppColors.textPrimary,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isLogout ? AppColors.error : AppColors.textPrimary,
                ),
              ),
            ),
            if (showTrailing)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
