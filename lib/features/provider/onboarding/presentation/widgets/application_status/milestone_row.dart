import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class MilestoneRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;
  final bool isError;
  final bool isLast;

  const MilestoneRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isActive = false,
    this.isError = false,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    Color nodeColor = isError
        ? AppColors.error
        : (isCompleted
              ? AppColors.primary
              : (isActive ? AppColors.warning : AppColors.divider));

    IconData nodeIcon = isError
        ? Icons.close
        : (isCompleted
              ? Icons.check
              : (isActive ? Icons.more_horiz : Icons.lock_outline));

    Color iconColor = (isCompleted || isActive || isError)
        ? Colors.white
        : AppColors.textHint;

    Color titleColor = isError
        ? AppColors.error
        : (isCompleted || isActive
              ? AppColors.textPrimary
              : AppColors.textSecondary);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Column
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Node
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: nodeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(nodeIcon, color: iconColor, size: 16),
                ),
                // Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          // Content Column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.xl, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 15,
                      fontWeight: isCompleted || isActive || isError
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
