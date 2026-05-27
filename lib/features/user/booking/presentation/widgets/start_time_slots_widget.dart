import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';

class StartTimeSlotsWidget extends StatelessWidget {
  final List<String> timeSlots;
  final List<String> availableSlots;
  final String selectedTime;
  final ValueChanged<String> onTimeSelected;

  const StartTimeSlotsWidget({
    super.key,
    required this.timeSlots,
    required this.availableSlots,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Start Time', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.md),
        Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.sm,
          children: timeSlots.map((time) {
            final isSelected = time == selectedTime;
            final isAvailable = availableSlots.contains(time);

            return InkWell(
              onTap: isAvailable ? () => onTimeSelected(time) : null,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.9)
                      : isAvailable
                      ? Colors.transparent
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : isAvailable
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  DateTimeUtils.formatTo12Hour(time),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected
                        ? Colors.white
                        : isAvailable
                        ? AppColors.textPrimary
                        : Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static Widget shimmer() {
    return StartTimeSlotsWidget(
      timeSlots: List.generate(5, (index) => '09:00'),
      availableSlots: List.generate(5, (index) => '09:00'),
      selectedTime: '',
      onTimeSelected: (_) {},
    );
  }
}
