import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class CategoryHeaderWidget extends StatelessWidget {
  final int selectedCount;

  const CategoryHeaderWidget({super.key, required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.sm + 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: const Icon(
            Icons.category_rounded,
            color: AppColors.primary,
            size: AppSizes.iconMd,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Text(
            'Select Categories',
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
        ),
        if (selectedCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm + 4,
              vertical: AppSizes.xs + 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              '$selectedCount selected',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
