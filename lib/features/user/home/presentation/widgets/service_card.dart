import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card_image.dart';

class ServiceCard extends StatelessWidget {
  final String? bannerImage;
  final String categoryIcon;
  final String providerName;
  final String categoryName;
  final double price;
  final double rating;
  final int reviews;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onTap;
  final bool isBookmarked;
  final bool isLoading;

  const ServiceCard({
    super.key,
    this.bannerImage,
    required this.categoryIcon,
    required this.providerName,
    required this.categoryName,
    required this.price,
    required this.rating,
    required this.reviews,
    this.onBookmarkTap,
    this.onTap,
    this.isBookmarked = false,
    this.isLoading = false,
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
            // Image / Icon Gradient
            ServiceCardImage(
              bannerImage: bannerImage,
              categoryIcon: categoryIcon,
              isLoading: isLoading,
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
                          style: TextStyle(
                            fontSize: 15.5,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: onBookmarkTap,
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_add_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  // Category Name
                  Text(
                    categoryName,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
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
                      fontSize: 14,
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
                      Text(
                        '${reviews > 1000 ? '${(reviews / 1000).toStringAsFixed(1)}k' : reviews} reviews',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
