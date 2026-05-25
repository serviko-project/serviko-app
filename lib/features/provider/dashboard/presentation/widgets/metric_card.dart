import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class MetricCard extends StatelessWidget {
  final MetricItem metric;

  const MetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
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
          // Title and Icon Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  metric.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSizes.xs),

              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: metric.bgColor,
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: metric.icon,
                  color: metric.iconColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Stat Value
          Text(
            metric.value,
            style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// Metric Item Model
class MetricItem {
  final String title;
  final String value;
  final List<List<dynamic>> icon;
  final Color iconColor;
  final Color bgColor;

  const MetricItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}
