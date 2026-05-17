import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class PromoCodeWidget extends StatelessWidget {
  final String selectedPromo;
  final VoidCallback onTap;

  const PromoCodeWidget({
    super.key,
    required this.selectedPromo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Promo Code', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.md),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_offer_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Text(
                    selectedPromo.isEmpty
                        ? 'Select a Promo Code'
                        : selectedPromo,
                    style: TextStyle(
                      color: selectedPromo.isEmpty
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontWeight: selectedPromo.isEmpty
                          ? FontWeight.normal
                          : FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Container(
                  width: AppSizes.inputHeight,
                  height: AppSizes.inputHeight,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Icon(
                    selectedPromo.isEmpty ? Icons.add : Icons.edit,
                    color: AppColors.primary,
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
