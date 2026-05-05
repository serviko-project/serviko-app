import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class OfferCardWidget extends StatelessWidget {
  const OfferCardWidget(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final gradients = [
      LinearGradient(
        colors: [AppColors.primary, AppColors.primary.withAlpha(150)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [AppColors.secondary, AppColors.secondary.withAlpha(150)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [AppColors.warning, AppColors.warning.withAlpha(150)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];
    final gradient = gradients[index % gradients.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '30%',
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
                Text(
                  "Today's Special.!!",
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Get discount for every order, only valid for today.',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: Colors.white.withAlpha(200),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              // Placeholder for the image
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: const Icon(Icons.image, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }
}
