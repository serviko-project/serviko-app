import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String providerName;
  final String serviceTitle;
  final double price;
  final double rating;
  final int reviews;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onTap;
  final bool isBookmarked;

  const ServiceCard({
    super.key,
    required this.imageUrl,
    required this.providerName,
    required this.serviceTitle,
    required this.price,
    required this.rating,
    required this.reviews,
    this.onBookmarkTap,
    this.onTap,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: AppColors.shimmerBase,
                    child: const Icon(Icons.image, color: AppColors.textHint),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSizes.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Provider Name & Bookmark
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          providerName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: onBookmarkTap,
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_add_outlined,
                          color: AppColors.primary,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  // Service Title
                  Text(
                    serviceTitle,
                    style: TextStyle(
                      fontSize: 15.5,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Price
                  Text(
                    '₹${price.toStringAsFixed(0)} / hr',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primary,
                      fontSize: 15,
                      letterSpacing: 0.25,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Rating & Reviews
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.warning,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: AppTextStyles.labelMedium,
                      ),
                      const SizedBox(width: 4),
                      Text('|', style: AppTextStyles.bodySmall),
                      const SizedBox(width: 4),
                      Text('$reviews reviews', style: AppTextStyles.bodySmall),
                    ],
                  ),
                  SizedBox(height: AppSizes.sm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
