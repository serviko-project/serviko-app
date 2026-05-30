import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_service_area_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_service_area_state.dart';

class CoverageRadiusSliderWidget extends StatelessWidget {
  const CoverageRadiusSliderWidget({
    super.key,
    required this.cubit,
    required this.state,
  });

  final EditProviderServiceAreaCubit cubit;
  final EditProviderServiceAreaState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Coverage Radius',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(15),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Text(
                '${state.coverageRadius.toInt()} km',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.background,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withAlpha(30),
            trackHeight: 6.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: state.coverageRadius,
            min: 1.0,
            max: 50.0,
            divisions: 49,
            onChanged: (value) => cubit.setCoverageRadius(value),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 km',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
            Text(
              '50 km',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
