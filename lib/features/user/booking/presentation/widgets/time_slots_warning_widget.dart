import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class TimeSlotsWarningWidget extends StatelessWidget {
  const TimeSlotsWarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.warning.withValues(alpha: 0.8),
            size: 20,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              'No available slots for this date and duration.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.warning.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
