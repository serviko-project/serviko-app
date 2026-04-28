import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'dart:ui';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/timeline_step_item.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/application_status/trust_badge.dart';

class WelcomeView extends StatelessWidget {
  WelcomeView({super.key});

  final List<Map<String, dynamic>> _steps = [
    {
      'icon': Icons.assignment_rounded,
      'title': 'Apply in Minutes',
      'description': 'Fill out your details and select your service area.',
      'color': AppColors.primary,
    },
    {
      'icon': Icons.verified_user_rounded,
      'title': 'Get Verified',
      'description': 'Our team reviews your profile within 24 hours.',
      'color': AppColors.secondary,
    },
    {
      'icon': Icons.payments_rounded,
      'title': 'Start Earning',
      'description': 'Accept bookings, work your schedule and grow.',
      'color': AppColors.success,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary.withAlpha(20), Colors.white],
          stops: const [0.0, 0.3],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: Column(
                children: [
                  // Lottie
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                      border: Border.all(color: Colors.white.withAlpha(100)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Lottie.asset(
                          AppAssets.providerOnboarding,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.business_center_rounded,
                                size: 80,
                                color: AppColors.primary,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl * 1.5),

                  // Provider Application Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          'Provider Application',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // Title
                  Text(
                    'Earn on Your Terms',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // Trust Badge
                  const TrustBadge(),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // How it works section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How it works',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  ...List.generate(_steps.length, (index) {
                    final step = _steps[index];
                    return TimelineStepItem(
                      icon: step['icon'] as IconData,
                      title: step['title'] as String,
                      description: step['description'] as String,
                      color: step['color'] as Color,
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.md),

            // Footer Card
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                  color: AppColors.textSecondary.withAlpha(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Text(
                      'Takes approx. 5 mins. Have your Government ID and valid work certificates handy.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }
}
