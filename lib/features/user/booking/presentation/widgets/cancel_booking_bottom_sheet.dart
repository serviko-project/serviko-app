import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

class CancelBookingBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const CancelBookingBottomSheet({super.key, required this.onConfirm});

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => CancelBookingBottomSheet(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.screenPadding,
        right: AppSizes.screenPadding,
        top: 12,
        bottom: AppSizes.screenPadding * 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Title
          Text(
            'Cancel Booking',
            style: AppTextStyles.h3.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: AppSizes.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSizes.lg),

          // Confirmation Message
          Text(
            'Are you sure want to cancel your\nservice booking?',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xl),

          // Divider
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSizes.lg),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'No, Keep It',
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  textColor: AppColors.primary,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: CustomButton(
                  text: 'Yes, Cancel',
                  backgroundColor: AppColors.error,
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
