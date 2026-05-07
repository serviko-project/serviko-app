import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String providerName;
  final List<String> categories;
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
    this.categories = const [],
    required this.price,
    required this.rating,
    required this.reviews,
    this.onBookmarkTap,
    this.onTap,
    this.isBookmarked = false,
  });

  String _formatCategories(List<String> categories) {
    if (categories.isEmpty) return '';
    if (categories.length <= 2) {
      return categories.join(' • ');
    }
    final remaining = categories.length - 2;
    return '${categories.take(2).join(' • ')} (+$remaining)';
  }

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
                  const SizedBox(height: 2),

                  // Selected Categories
                  Text(
                    _formatCategories(categories),
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
