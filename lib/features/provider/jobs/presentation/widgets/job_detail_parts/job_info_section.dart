import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

class JobInfoSection extends StatelessWidget {
  final BookingEntity booking;

  const JobInfoSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Information',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSizes.md),

        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // Date
              _InfoRow(
                icon: Icons.calendar_today_rounded,
                label: 'Date',
                value: DateTimeUtils.formatToReadableDate(
                  booking.scheduledDate,
                ),
              ),
              const Divider(height: AppSizes.lg),

              // Time Range
              _InfoRow(
                icon: Icons.access_time_rounded,
                label: 'Time',
                value:
                    '${DateTimeUtils.formatTo12Hour(booking.startTime)} - ${DateTimeUtils.formatTo12Hour(booking.endTime)}',
              ),
              const Divider(height: AppSizes.lg),

              // Duration
              _InfoRow(
                icon: Icons.timer_outlined,
                label: 'Duration',
                value:
                    '${booking.durationHours} hour${booking.durationHours > 1 ? 's' : ''}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSizes.sm),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
