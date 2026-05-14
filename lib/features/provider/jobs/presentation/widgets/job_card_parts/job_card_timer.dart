import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class JobCardTimer extends StatelessWidget {
  final Duration timeLeft;

  const JobCardTimer({super.key, required this.timeLeft});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 4,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.warning, size: 16),
          const SizedBox(width: 8),
          Text(
            'Expires in : ',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _formatDuration(timeLeft),
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.warning.withValues(alpha: 0.9),
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
