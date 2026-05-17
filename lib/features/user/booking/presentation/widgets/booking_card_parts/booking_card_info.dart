import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookingCardInfo extends StatelessWidget {
  final String date;
  final String timeRange;
  final String totalFormatted;

  const BookingCardInfo({
    super.key,
    required this.date,
    required this.timeRange,
    required this.totalFormatted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoColumn(
            icon: HugeIcons.strokeRoundedCalendar03,
            title: 'Date',
            value: date,
          ),
          _buildInfoColumn(
            icon: HugeIcons.strokeRoundedClock01,
            title: 'Time',
            value: timeRange,
          ),
          _buildInfoColumn(
            icon: HugeIcons.strokeRoundedMoney01,
            title: 'Total',
            value: totalFormatted,
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn({
    required dynamic icon,
    required String title,
    required String value,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Skeleton.replace(
              child: HugeIcon(
                icon: icon,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
