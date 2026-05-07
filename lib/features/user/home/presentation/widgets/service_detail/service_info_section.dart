import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

// Service Information Section
class ServiceInfoSection extends StatelessWidget {
  final int serviceIndex;

  const ServiceInfoSection({super.key, required this.serviceIndex});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['Category 1', 'Category 2', 'Category 3'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.sm),

          // Provider Name
          Text(
            'Provider ${serviceIndex + 1}',
            style: AppTextStyles.h1.copyWith(fontSize: 22),
          ),
          const SizedBox(height: AppSizes.sm),

          // Professional title
          Text(
            'Professional Title',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
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

              Text('4.8', style: AppTextStyles.h3),

              Text(
                '(4,479 reviews)',
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
                  'Service Location Area',
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
            children: categories.map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  border: Border.all(
                    color: AppColors.primary.withAlpha(40),
                    width: 1,
                  ),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.lg),

          // Price
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '₹${(20 + serviceIndex * 5).toStringAsFixed(0)}',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: '  / hr (Starting Rate)',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
