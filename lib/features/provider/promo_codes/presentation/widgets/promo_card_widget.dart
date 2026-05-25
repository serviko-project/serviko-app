import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/provider_promo_cubit.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/promo_info_column.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/edit_promo_bottom_sheet.dart';
import 'package:intl/intl.dart';

class PromoCardWidget extends StatelessWidget {
  final PromoCode promo;
  final ProviderPromoCubit cubit;

  const PromoCardWidget({super.key, required this.promo, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final discountStr = promo.discountType == 'percentage'
        ? '${promo.discountValue.toStringAsFixed(0)}%'
        : '₹${promo.discountValue.toStringAsFixed(0)}';

    final maxDiscountStr =
        promo.discountType == 'percentage' && promo.maxDiscountAmount != null
        ? ' (Up to ₹${promo.maxDiscountAmount!.toStringAsFixed(0)})'
        : '';

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: promo.isActive
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Promo Code
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  promo.code,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // Edit Button & Active Switch
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.background,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppSizes.radiusLg),
                          ),
                        ),
                        builder: (modalContext) =>
                            EditPromoBottomSheet(cubit: cubit, promo: promo),
                      );
                    },
                  ),
                  Switch.adaptive(
                    value: promo.isActive,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) {
                      if (value) {
                        cubit.updatePromo(promoId: promo.id, isActive: true);
                      } else {
                        cubit.deactivatePromo(promo.id);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),

          // Description
          if (promo.description != null) ...[
            Text(
              promo.description!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
          ],
          const Divider(height: 16),

          // Discount Value, Min Booking Amount, Usage Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PromoInfoColumn(
                label: "Discount Value",
                value: '$discountStr$maxDiscountStr',
              ),
              PromoInfoColumn(
                label: "Min Booking",
                value: promo.minBookingAmount != null
                    ? '₹${promo.minBookingAmount!.toStringAsFixed(0)}'
                    : 'None',
              ),
              PromoInfoColumn(
                label: "Usage Info",
                value: '${promo.usageCount} / ${promo.maxUses ?? "∞"} used',
              ),
            ],
          ),

          // Expiry Date
          if (promo.expiresAt != null) ...[
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: AppColors.error,
                ),
                const SizedBox(width: AppSizes.xs),
                Text(
                  'Expires: ${DateFormat('dd MMM yyyy').format(promo.expiresAt!)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
