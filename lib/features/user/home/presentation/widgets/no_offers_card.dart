import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/promo_card_painter.dart';

// Widget to display when there are no active offers available
class NoOffersCard extends StatelessWidget {
  const NoOffersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.primary.withValues(alpha: 0.08);
    final borderColor = AppColors.primary.withValues(alpha: 0.24);
    final accentColor = AppColors.primary;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.xs,
        vertical: 6.0,
      ),
      child: CustomPaint(
        painter: PromoCardPainter(
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          dashColor: accentColor.withValues(alpha: 0.24),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md + 2,
            vertical: AppSizes.sm,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 13,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon and Title Row
                    Row(
                      children: [
                        Icon(
                          Icons.discount_outlined,
                          color: accentColor.withValues(alpha: 0.7),
                          size: 22,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Expanded(
                          child: Text(
                            "No Active Offers",
                            style: AppTextStyles.h3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      "We are waiting actively for new promotional offers. Stay tuned!",
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.lg),
              // Decorative Icon : Hourglass
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withValues(alpha: 0.09),
                  ),
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Icon(
                    Icons.hourglass_empty_rounded,
                    color: accentColor.withValues(alpha: 0.7),
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
