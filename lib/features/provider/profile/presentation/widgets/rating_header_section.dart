import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_reviews_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RatingHeaderSection extends StatelessWidget {
  const RatingHeaderSection({
    super.key,
    required this.isLoading,
    required this.state,
  });

  final bool isLoading;
  final ProviderReviewsState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              state.averageRating > 0
                  ? state.averageRating.toStringAsFixed(1)
                  : (isLoading ? '4.5' : '0.0'),
              style: TextStyle(
                fontFamily: AppTextStyles.h1.fontFamily,
                fontSize: 72,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '/ 5',
              style: TextStyle(
                fontFamily: AppTextStyles.h1.fontFamily,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        // 5 Star Row
        Skeleton.ignore(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final double starRating = isLoading
                  ? 4.5
                  : (state.averageRating > 0 ? state.averageRating : 0.0);
              final int floorRating = starRating.floor();
              IconData iconData = Icons.star_border_rounded;
              Color color = AppColors.border;

              if (index < floorRating) {
                iconData = Icons.star_rounded;
                color = AppColors.warning;
              } else if (index == floorRating &&
                  (starRating - floorRating) >= 0.25) {
                if ((starRating - floorRating) >= 0.75) {
                  iconData = Icons.star_rounded;
                  color = AppColors.warning;
                } else {
                  iconData = Icons.star_half_rounded;
                  color = AppColors.warning;
                }
              }

              return Icon(iconData, color: color, size: 32);
            }),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          isLoading
              ? 'Based on 10 reviews'
              : 'Based on ${state.totalReviews} reviews',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSizes.xxl),
      ],
    );
  }
}
