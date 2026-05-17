import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class ViewBookingReasonCard extends StatelessWidget {
  final String reason;

  const ViewBookingReasonCard({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.1)),
      ),
      child: Text(
        reason,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.error,
          height: 1.5,
        ),
      ),
    );
  }
}
