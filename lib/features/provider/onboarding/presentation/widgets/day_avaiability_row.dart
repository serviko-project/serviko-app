import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

class DayAvailabilityRow extends StatelessWidget {
  final String dayName;
  final DayAvailability availability;
  final VoidCallback onToggle;
  final VoidCallback onStartTimeTap;
  final VoidCallback onEndTimeTap;

  const DayAvailabilityRow({
    super.key,
    required this.dayName,
    required this.availability,
    required this.onToggle,
    required this.onStartTimeTap,
    required this.onEndTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = availability.isEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dayName,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: isEnabled ? FontWeight.w600 : FontWeight.w500,
                color: isEnabled ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: (value) => onToggle(),
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withAlpha(50),
              inactiveThumbColor: AppColors.textHint,
              inactiveTrackColor: AppColors.border,
            ),
          ],
        ),
        if (isEnabled) ...[
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(
                child: _TimePickerContainer(
                  time: DateTimeUtils.formatTimeOfDayTo12Hour(
                    availability.startTime,
                  ),
                  onTap: onStartTimeTap,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textHint,
                  size: 16,
                ),
              ),
              Expanded(
                child: _TimePickerContainer(
                  time: DateTimeUtils.formatTimeOfDayTo12Hour(
                    availability.endTime,
                  ),
                  onTap: onEndTimeTap,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _TimePickerContainer extends StatelessWidget {
  final String time;
  final VoidCallback onTap;

  const _TimePickerContainer({required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 16,
              color: AppColors.primary.withAlpha(200),
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
