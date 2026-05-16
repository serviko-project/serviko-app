import 'package:flutter/material.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';

class JobCardHeader extends StatelessWidget {
  final BookingEntity booking;
  final BookingStatus status;

  const JobCardHeader({super.key, required this.booking, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: booking.customerImage != null
              ? NetworkImage(booking.customerImage!)
              : null,
          child: booking.customerImage == null
              ? const Icon(Icons.person)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.customerName ?? 'Customer',
                style: AppTextStyles.h3.copyWith(fontSize: 14),
              ),
              Text(
                booking.categoryName ?? 'Service',
                style: AppTextStyles.labelSmall,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: status.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            status.displayLabel.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: status.color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
