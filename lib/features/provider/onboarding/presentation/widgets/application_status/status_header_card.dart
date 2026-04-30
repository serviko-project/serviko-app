import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';

class StatusHeaderCard extends StatelessWidget {
  final ProviderStatus status;

  const StatusHeaderCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (title, subtitle, icon, color) = _getStatusData();

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: AppSizes.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withAlpha(25), color.withAlpha(5)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: color.withAlpha(30), width: 1),
      ),
      child: Column(
        children: [
          // Icon with circular background and shadow
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(40),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: AppSizes.lg),
          // Title and subtitle
          Text(
            title,
            style: AppTextStyles.h2.copyWith(height: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            subtitle,
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

  (String, String, IconData, Color) _getStatusData() {
    return switch (status) {
      ProviderStatus.pending => (
        'Application Under Review',
        'Our team is currently verifying your details. This usually takes 24-48 hours.',
        Icons.hourglass_top_rounded,
        AppColors.primary,
      ),
      ProviderStatus.approved => (
        'Application Approved!',
        'Congratulations! Your provider profile is now active and ready for jobs.',
        Icons.check_circle_outline_rounded,
        AppColors.success,
      ),
      ProviderStatus.rejected => (
        'Application Rejected',
        'Unfortunately, your application did not meet our criteria at this time.',
        Icons.cancel_outlined,
        AppColors.error,
      ),
      ProviderStatus.blocked => (
        'Account Blocked',
        'Your access to the provider platform has been restricted by the administrator.',
        Icons.block_flipped,
        AppColors.error,
      ),
      _ => (
        'Unknown Status',
        'Please contact support for more information.',
        Icons.help_outline_rounded,
        AppColors.textHint,
      ),
    };
  }
}
