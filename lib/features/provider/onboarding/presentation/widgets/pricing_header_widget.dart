import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class PricingHeaderWidget extends StatelessWidget {
  final int missingPriceCount;
  final bool showPriceValidation;

  const PricingHeaderWidget({
    super.key,
    required this.missingPriceCount,
    required this.showPriceValidation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.sm + 2),
          decoration: BoxDecoration(
            color: AppColors.secondary.withAlpha(20),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: const Icon(
            Icons.attach_money_rounded,
            color: AppColors.secondary,
            size: AppSizes.iconMd,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set Your Rates',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 16,
                  letterSpacing: 0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                'Enter your hourly rate for each service',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (missingPriceCount > 0 && showPriceValidation)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm + 4,
              vertical: AppSizes.xs + 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(20),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              '$missingPriceCount missing',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }
}
