import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';

class JobCardPrice extends StatelessWidget {
  final BookingEntity booking;

  const JobCardPrice({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final String paymentText;
    final Color statusColor;

    if (booking.paymentStatus == 'paid') {
      paymentText = 'Paid';
      statusColor = AppColors.success;
    } else if (booking.paymentStatus == 'refunded') {
      paymentText = 'Refunded';
      statusColor = AppColors.info;
    } else if (booking.status == BookingStatus.cancelled ||
        booking.status == BookingStatus.expired ||
        booking.status == BookingStatus.rejected) {
      paymentText = 'No Payment Due';
      statusColor = AppColors.textSecondary;
    } else {
      paymentText = 'Payment Pending';
      statusColor = AppColors.warning;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Earning',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Rs. ${booking.totalPrice.toStringAsFixed(2)}',
              style: AppTextStyles.h3,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            paymentText,
            style: AppTextStyles.bodySmall.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
