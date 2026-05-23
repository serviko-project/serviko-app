import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

// Card to display the completion note left by the provider
class ViewBookingCompletionNoteCard extends StatelessWidget {
  final String note;

  const ViewBookingCompletionNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: const Border(
          left: BorderSide(color: AppColors.success, width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_rounded,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              note,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
