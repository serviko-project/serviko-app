import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_request_payload.dart';

class SummaryPriceCard extends StatelessWidget {
  final BookingRequestPayload payload;

  const SummaryPriceCard({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final basePricePerHour = payload.initData.basePricePerHour;
    final hours = payload.workingHours;
    final subtotal = basePricePerHour * hours;

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        spacing: AppSizes.md,
        children: [
          _buildPriceRow(
            "Service Fee (${payload.initData.categoryName})",
            "₹${basePricePerHour.toStringAsFixed(0)} x $hours",
            "₹${subtotal.toStringAsFixed(2)}",
          ),
          if (payload.promoCode.isNotEmpty) ...[
            Divider(color: AppColors.border.withValues(alpha: 0.5)),
            _buildPriceRow(
              "Promo Applied",
              "Code: ${payload.promoCode}",
              "-₹${payload.discountAmount.toStringAsFixed(2)}",
              valueColor: AppColors.success,
            ),
          ],
          Divider(color: AppColors.border.withValues(alpha: 0.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                "₹${payload.totalPrice.toStringAsFixed(2)}",
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String subtitle,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
