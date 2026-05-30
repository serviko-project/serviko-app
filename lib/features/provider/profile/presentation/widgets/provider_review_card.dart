import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/features/user/booking/domain/entities/review_entity.dart';

class ProviderReviewCard extends StatelessWidget {
  final ReviewEntity review;

  const ProviderReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Customer Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: review.customerImage != null
                    ? CachedNetworkImage(imageUrl: review.customerImage!)
                    : Text(review.customerName[0].toUpperCase()),
              ),
              const SizedBox(width: AppSizes.sm),

              // Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateTimeUtils.formatToUppercaseCustomDate(
                        review.createdAt,
                      ),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (starIndex) {
                  return Icon(
                    Icons.star_rounded,
                    color: starIndex < review.rating
                        ? AppColors.warning
                        : AppColors.border,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Review Comment
          Text(
            '"${review.comment}"',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
