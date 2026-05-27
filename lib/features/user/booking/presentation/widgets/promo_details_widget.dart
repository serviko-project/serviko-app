import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';

class PromoDetailsWidget extends StatelessWidget {
  const PromoDetailsWidget({super.key, required this.promo});

  final PromoCode promo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Promo Code
              Row(
                children: [
                  Icon(Icons.local_offer, color: AppColors.primary, size: 20),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    promo.code,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Apply Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context, promo);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(60, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("Apply"),
              ),
            ],
          ),

          // Description
          if (promo.description != null && promo.description!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.xs),
            Text(
              promo.description!,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSizes.xs),

          // Discount Info
          Text(
            promo.discountType.toLowerCase() == 'percentage'
                ? 'Get ${promo.discountValue.toStringAsFixed(0)}% off'
                : 'Flat ₹${promo.discountValue.toStringAsFixed(0)} off',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Max Discount for Percentage
          if (promo.minBookingAmount != null &&
              promo.minBookingAmount! > 0) ...[
            const SizedBox(height: AppSizes.xs),
            Text(
              "Valid on orders above ₹${promo.minBookingAmount!.toStringAsFixed(0)}",
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
