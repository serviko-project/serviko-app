import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

// Policy Section Card
class PolicySectionCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const PolicySectionCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.screenPadding),
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: .5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .02),
            blurRadius: AppSizes.radiusSm,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title with Icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: const Skeleton.keep(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedCircle,
                    color: AppColors.primary,
                    size: AppSizes.iconSm,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSizes.md),

          ...items.map((item) {
            if (item.startsWith('*')) {
              // Bullet item
              final text = item.replaceFirst('*', '').trim();
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSizes.sm,
                  left: AppSizes.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        text,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Plain text paragraph
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: Text(
                  item,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
