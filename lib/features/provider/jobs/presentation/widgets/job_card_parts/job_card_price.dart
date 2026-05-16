import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

class JobCardPrice extends StatelessWidget {
  final BookingEntity booking;

  const JobCardPrice({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Earning',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '₹ ${booking.totalPrice.toStringAsFixed(2)}',
          style: AppTextStyles.h3,
        ),
      ],
    );
  }
}
