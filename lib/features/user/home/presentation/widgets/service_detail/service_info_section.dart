import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';

// Service Information Section
class ServiceInfoSection extends StatelessWidget {
  final String providerName;
  final String? providerImage;
  final String? selectedCategoryId;
  final List<ProviderServiceEntity> categories;
  final double rating;
  final int reviewsCount;
  final String professionalTitle;
  final int? yearsOfExperience;
  final String? address;
  final Function(ProviderServiceEntity)? onServiceSelected;

  const ServiceInfoSection({
    super.key,
    required this.providerName,
    this.providerImage,
    this.selectedCategoryId,
    required this.categories,
    required this.rating,
    required this.reviewsCount,
    required this.professionalTitle,
    this.yearsOfExperience,
    this.address,
    this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.sm),

          // Provider Name
          Text(providerName, style: AppTextStyles.h1.copyWith(fontSize: 22)),
          const SizedBox(height: AppSizes.sm),

          // Professional title & Experience
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                professionalTitle,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (yearsOfExperience != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(25),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Text(
                    '$yearsOfExperience+ Years Exp.',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Rating, Reviews & Location
          Row(
            spacing: 4,
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.warning,
                size: 18,
              ),
              Text(rating.toStringAsFixed(1), style: AppTextStyles.h3),
              Text(
                '($reviewsCount Reviews)',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
              Expanded(
                child: Text(
                  address ?? 'Location not available',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),

          // Services Offered
          Text(
            'Services Offered',
            style: AppTextStyles.h3.copyWith(fontSize: 16),
          ),
          const SizedBox(height: AppSizes.sm + 2),

          // Categories Chips
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: categories.map((service) {
              final bool isSelected = service.categoryId == selectedCategoryId;
              return GestureDetector(
                onTap: () => onServiceSelected?.call(service),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withAlpha(40),
                      width: 1,
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: service.categoryName,
                          style: AppTextStyles.labelSmall.copyWith(
                            letterSpacing: 0.5,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' - ₹${service.basePricePerHour}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isSelected
                                ? Colors.white.withAlpha(200)
                                : AppColors.primary.withAlpha(180),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
