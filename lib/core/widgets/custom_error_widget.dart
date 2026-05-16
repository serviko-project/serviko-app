import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final IconData? icon;
  final bool isFullPage;

  const CustomErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon,
    this.isFullPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.xl,
        vertical: isFullPage ? 0 : AppSizes.xl,
      ),
      child: Column(
        mainAxisAlignment: isFullPage
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: isFullPage ? MainAxisSize.max : MainAxisSize.min,
        children: [
          // Error Icon
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.error_outline_rounded,
              color: AppColors.error,
              size: 48,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // Error Message
          Text(
            'Something went wrong',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xl),
          // Retry Button
          CustomButton(text: 'Try Again', onPressed: onRetry, width: 160),
        ],
      ),
    );
  }
}
