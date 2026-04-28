import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class StatusHeaderCard extends StatelessWidget {
  final bool isRejected;

  const StatusHeaderCard({super.key, required this.isRejected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: AppSizes.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isRejected
              ? [AppColors.error.withAlpha(25), AppColors.error.withAlpha(5)]
              : [
                  AppColors.primary.withAlpha(25),
                  AppColors.primaryLight.withAlpha(5),
                ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: isRejected
              ? AppColors.error.withAlpha(30)
              : AppColors.primary.withAlpha(30),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isRejected ? AppColors.error : AppColors.primary)
                      .withAlpha(40),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isRejected ? Icons.cancel_outlined : Icons.hourglass_top_rounded,
              color: isRejected ? AppColors.error : AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            isRejected ? 'Application Rejected' : 'Application Under\nReview',
            style: AppTextStyles.h2.copyWith(height: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            isRejected
                ? 'Unfortunately, your application did not meet our criteria at this time.'
                : 'Our team is currently verifying your\ndetails',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
