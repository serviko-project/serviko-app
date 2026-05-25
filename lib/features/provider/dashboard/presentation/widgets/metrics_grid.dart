import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'metric_card.dart';

// Metrics grid displaying dashboard statistics
class MetricsGrid extends StatelessWidget {
  final double todayEarnings;
  final int activeJobsCount;
  final int newRequestsCount;
  final double rating;

  const MetricsGrid({
    super.key,
    required this.todayEarnings,
    required this.activeJobsCount,
    required this.newRequestsCount,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = [
      MetricItem(
        title: "Today's Earnings",
        value: "₹${todayEarnings.toStringAsFixed(2)}",
        icon: HugeIcons.strokeRoundedMoney03,
        iconColor: AppColors.success,
        bgColor: AppColors.success.withValues(alpha: 0.1),
      ),
      MetricItem(
        title: 'Active Jobs',
        value: activeJobsCount.toString(),
        icon: HugeIcons.strokeRoundedBriefcase01,
        iconColor: AppColors.primary,
        bgColor: AppColors.primary.withValues(alpha: 0.1),
      ),
      MetricItem(
        title: 'New Requests',
        value: newRequestsCount.toString(),
        icon: HugeIcons.strokeRoundedNotification03,
        iconColor: AppColors.warning,
        bgColor: AppColors.warning.withValues(alpha: 0.1),
      ),
      MetricItem(
        title: 'Avg Rating',
        value: rating > 0 ? rating.toStringAsFixed(1) : '5.0',
        icon: HugeIcons.strokeRoundedStar,
        iconColor: AppColors.info,
        bgColor: AppColors.info.withValues(alpha: 0.1),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Today's Earnings and Active Jobs Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: MetricCard(metric: metrics[0])),
              const SizedBox(width: AppSizes.sm),
              Expanded(child: MetricCard(metric: metrics[1])),
            ],
          ),
          const SizedBox(height: AppSizes.sm),

          // New Requests and Avg Rating Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: MetricCard(metric: metrics[2])),
              const SizedBox(width: AppSizes.sm),
              Expanded(child: MetricCard(metric: metrics[3])),
            ],
          ),
        ],
      ),
    );
  }
}
