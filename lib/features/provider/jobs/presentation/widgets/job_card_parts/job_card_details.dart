import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

class JobCardDetails extends StatelessWidget {
  final BookingEntity booking;

  const JobCardDetails({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        // Date
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: DateFormat(
            'EEE, MMM d, yyyy',
          ).format(DateTime.parse(booking.scheduledDate)),
        ),
        // Time & Duration
        _InfoRow(
          icon: Icons.access_time,
          label:
              '${booking.startTime} - ${booking.endTime} (${booking.durationHours} hrs)',
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
        Icon(icon, size: 16, color: theme.hintColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
