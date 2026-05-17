import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

class JobCardDetails extends StatelessWidget {
  final BookingEntity booking;

  const JobCardDetails({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.sm,
      children: [
        // Date
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: DateTimeUtils.formatToReadableDate(booking.scheduledDate),
        ),
        // Time & Duration
        _InfoRow(
          icon: Icons.access_time,
          label:
              '${DateTimeUtils.formatTo12Hour(booking.startTime)} - ${DateTimeUtils.formatTo12Hour(booking.endTime)} (${booking.durationHours} hrs)',
        ),
        // Location
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: booking.customerAddress ?? 'No address provided',
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: AppSizes.iconSm, color: theme.hintColor),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppTextStyles.bodyMedium.color?.withValues(alpha: 0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
