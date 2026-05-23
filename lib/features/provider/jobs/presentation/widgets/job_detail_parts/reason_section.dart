import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class ReasonSection extends StatelessWidget {
  final String title;
  final String reason;

  const ReasonSection({super.key, required this.title, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.1)),
          ),
          child: Text(
            reason,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.red.shade900,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
