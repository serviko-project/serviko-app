import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/coverage_radius_widget.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';

class ServiceAreaView extends StatelessWidget {
  const ServiceAreaView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSizes.lg),
          // Top Information Banner
          const InfoBanner(
            text:
                'Define your service radius based on your current location. You will only receive bookings within this zone.',
          ),
          const SizedBox(height: AppSizes.xl),

          // Map Placeholder
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(5),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(
                color: AppColors.primary.withAlpha(30),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.location_on,
              color: AppColors.primary.withAlpha(220),
              size: 40,
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // Current Location info
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.border.withAlpha(150)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: AppColors.primary.withAlpha(200),
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Malappuram. Kerala',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Edit',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xl),

          // Radius Slider
          const CoverageRadiusWidget(),

          const SizedBox(height: AppSizes.xl),

          // Estimated Reach Banner
          const InfoBanner(
            text: 'Estimated reach: ~12,000 customers',
            icon: Icons.people_alt_outlined,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSizes.xl * 2),
        ],
      ),
    );
  }
}
