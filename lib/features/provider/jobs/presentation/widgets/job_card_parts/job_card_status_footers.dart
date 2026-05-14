import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';

// Job Card Expired Footer
class JobCardExpiredFooter extends StatelessWidget {
  const JobCardExpiredFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 4,
        vertical: AppSizes.sm + 2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, color: Colors.grey.shade600, size: 16),
          const SizedBox(width: 8),
          Text(
            'Request Expired',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Job Card Rejection Footer with reason
class JobCardRejectionFooter extends StatelessWidget {
  final String reason;

  const JobCardRejectionFooter({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 4,
        vertical: AppSizes.sm + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.red, size: 14),
              const SizedBox(width: 6),
              Text(
                'Rejection Reason',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            reason,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.red.shade900,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
