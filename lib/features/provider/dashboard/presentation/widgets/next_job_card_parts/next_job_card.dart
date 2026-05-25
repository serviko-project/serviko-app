import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'next_job_empty_state.dart';
import 'next_job_header.dart';
import 'next_job_details.dart';
import 'next_job_actions.dart';

// Next scheduled job card for provider dashboard
class NextJobCard extends StatelessWidget {
  const NextJobCard({super.key, this.booking});

  final BookingEntity? booking;

  @override
  Widget build(BuildContext context) {
    if (booking == null) {
      return const NextJobEmptyState();
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          NextJobHeader(
            customerName: booking!.customerName,
            customerImage: booking!.customerImage,
            categoryName: booking!.categoryName,
          ),
          const Divider(height: 1, color: AppColors.border),

          // Details section
          NextJobDetails(
            scheduledDate: booking!.scheduledDate,
            startTime: booking!.startTime,
            endTime: booking!.endTime,
            durationHours: booking!.durationHours,
            customerAddress: booking!.customerAddress,
          ),
          const Divider(height: 1, color: AppColors.border),

          // Price and Actions
          NextJobActions(booking: booking!),
        ],
      ),
    );
  }
}
