import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class CompletionNoteSection extends StatelessWidget {
  final String note;

  const CompletionNoteSection({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completion Note',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  note,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.green.shade900,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
