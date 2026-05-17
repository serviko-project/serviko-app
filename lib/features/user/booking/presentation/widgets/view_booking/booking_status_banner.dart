import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';

class BookingStatusBanner extends StatelessWidget {
  final BookingStatus status;

  const BookingStatusBanner({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: status.color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(status.icon, color: status.color, size: 20),
          ),
          SizedBox(width: AppSizes.md),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.displayLabel,
                  style: AppTextStyles.h3.copyWith(
                    color: status.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (status.bannerText.isNotEmpty) ...[
                  SizedBox(height: AppSizes.xs),
                  Text(
                    status.bannerText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: status.color.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
