import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import '../../domain/entities/earnings_summary_entity.dart';

class CustomEarningsGraph extends StatelessWidget {
  final EarningsSummaryEntity summary;

  const CustomEarningsGraph({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(summary.filter),
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  summary.periodLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+₹${summary.periodEarnings.toStringAsFixed(2)}',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              maxY: _getMaxY(summary.graphData),
              minY: 0,
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => Colors.black,
                  tooltipBorderRadius: BorderRadius.circular(20),
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  tooltipMargin: AppSizes.sm,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '₹${spot.y.toStringAsFixed(2)}',
                        AppTextStyles.labelMedium.copyWith(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value % 1 != 0) {
                        return const SizedBox.shrink();
                      }
                      final index = value.toInt();
                      if (index < 0 || index >= summary.graphData.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: AppSizes.sm),
                        child: Text(
                          summary.graphData[index].label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    interval: _getMaxY(summary.graphData) / 3 > 0
                        ? _getMaxY(summary.graphData) / 3
                        : 1,
                    getTitlesWidget: (value, meta) {
                      if (value < 0 || value > _getMaxY(summary.graphData)) {
                        return const SizedBox.shrink();
                      }
                      final String formattedValue;
                      if (value >= 1000) {
                        formattedValue =
                            '₹${(value / 1000).toStringAsFixed(1)}k';
                      } else {
                        formattedValue = '₹${value.toStringAsFixed(0)}';
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSizes.sm),
                        child: Text(
                          formattedValue,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _getMaxY(summary.graphData) / 3 > 0
                    ? _getMaxY(summary.graphData) / 3
                    : 1,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: summary.graphData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.value);
                  }).toList(),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.3),
                        AppColors.primary.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getTitle(String filter) {
    switch (filter) {
      case 'Daily':
        return 'Today';
      case 'Weekly':
        return 'This Week';
      case 'Monthly':
        return 'This Month';
      case 'Yearly':
        return 'This Year';
      default:
        return 'Earnings';
    }
  }

  double _getMaxY(List<GraphDataPointEntity> data) {
    if (data.isEmpty) return 100;
    double max = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    if (max == 0) return 100;
    return max * 1.2;
  }
}
