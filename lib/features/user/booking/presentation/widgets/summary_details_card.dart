import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_request_payload.dart';
import 'summary_info_item.dart';

class SummaryDetailsCard extends StatelessWidget {
  final BookingRequestPayload payload;

  const SummaryDetailsCard({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final dateformat = DateFormat('EEEE, MMM dd, yyyy');
    final formattedDate = dateformat.format(payload.selectedDate);
    final formattedTime = DateTimeUtils.formatTo12Hour(
      payload.selectedStartTime,
    );

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        spacing: AppSizes.lg,
        children: [
          SummaryInfoItem(
            icon: Icons.calendar_today_outlined,
            label: "Date",
            value: formattedDate,
          ),
          SummaryInfoItem(
            icon: Icons.access_time_outlined,
            label: "Time",
            value: "$formattedTime (${payload.workingHours} hrs)",
          ),
          SummaryInfoItem(
            icon: Icons.location_on_outlined,
            label: "Address",
            value: payload.customerAddress ?? 'Not selected',
          ),
        ],
      ),
    );
  }
}
