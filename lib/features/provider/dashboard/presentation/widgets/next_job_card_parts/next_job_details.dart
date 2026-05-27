import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';

// Details section of next scheduled job card (Date, Time, Location)
class NextJobDetails extends StatelessWidget {
  final String scheduledDate;
  final String startTime;
  final String endTime;
  final int durationHours;
  final String? customerAddress;

  const NextJobDetails({
    super.key,
    required this.scheduledDate,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    this.customerAddress,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateTimeUtils.formatToReadableDate(scheduledDate);
    final startTimeStr = DateTimeUtils.formatTo12Hour(startTime);
    final endTimeStr = DateTimeUtils.formatTo12Hour(endTime);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Date and time
          Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedClock01,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  '$dateStr  •  $startTimeStr - $endTimeStr (${durationHours}h)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm + 2),

          // Location / Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedLocation01,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  customerAddress ?? 'No address provided',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
