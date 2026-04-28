import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class TrustBadge extends StatelessWidget {
  const TrustBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.primary.withAlpha(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatars stack
          SizedBox(
            width: 75,
            height: 35,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withAlpha(30),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.secondary.withAlpha(30),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 18,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                Positioned(
                  left: 36,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.info.withAlpha(30),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 18,
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '4.8/5',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                'From 5,000+ providers',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
