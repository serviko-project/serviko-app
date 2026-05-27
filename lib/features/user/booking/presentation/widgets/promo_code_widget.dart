import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class PromoCodeWidget extends StatelessWidget {
  final String selectedPromo;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const PromoCodeWidget({
    super.key,
    required this.selectedPromo,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text('Offers & Discounts', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.md),

        // Promo Code Card
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_offer_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Text(
                    selectedPromo.isEmpty
                        ? 'View Available Offers'
                        : 'Promo Applied: $selectedPromo',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: selectedPromo.isEmpty
                          ? AppColors.textSecondary
                          : AppColors.primary,
                      fontWeight: selectedPromo.isEmpty
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                if (selectedPromo.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      if (onRemove != null) onRemove!();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
