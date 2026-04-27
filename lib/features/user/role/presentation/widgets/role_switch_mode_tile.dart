import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';

// Reusable tile widget for displaying each role option in the role switch dialog
class RoleSwitchModeTile extends StatelessWidget {
  const RoleSwitchModeTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.isEnabled = true,
    this.statusBadge,
    this.onTap,
  });

  final dynamic icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isEnabled;
  final Widget? statusBadge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tileColor = isSelected
        ? AppColors.primary.withAlpha(10)
        : AppColors.surface;
    final borderColor = isSelected
        ? AppColors.primary.withAlpha(80)
        : AppColors.border.withAlpha(120);
    final iconBg = isSelected
        ? AppColors.primary.withAlpha(20)
        : AppColors.border.withAlpha(60);
    final iconColor = isSelected ? AppColors.primary : AppColors.textHint;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isEnabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: HugeIcon(
                    icon: icon,
                    color: iconColor,
                    size: 22,
                    strokeWidth: 1.8,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Text + badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            color: isEnabled
                                ? AppColors.textPrimary
                                : AppColors.textHint,
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (statusBadge != null) ...[
                          const SizedBox(width: 10),
                          statusBadge!,
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEnabled
                            ? AppColors.textSecondary
                            : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),

              // Check indicator
              if (isSelected)
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                  color: AppColors.primary,
                  size: 25,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
