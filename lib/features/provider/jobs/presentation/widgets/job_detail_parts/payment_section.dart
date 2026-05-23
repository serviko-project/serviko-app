import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

class PaymentSection extends StatelessWidget {
  final BookingEntity booking;

  const PaymentSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Summary',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: AppSizes.md),
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _PaymentRow(
                label: 'Rate',
                value: '₹${booking.basePricePerHour.toStringAsFixed(0)}/hr',
              ),
              const SizedBox(height: AppSizes.sm),
              _PaymentRow(
                label: 'Duration',
                value:
                    '${booking.durationHours} hour${booking.durationHours > 1 ? 's' : ''}',
              ),
              const Divider(height: AppSizes.md),
              _PaymentRow(
                label: 'Total',
                value: '₹${booking.totalPrice.toStringAsFixed(0)}',
                isBold: true,
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Status',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  _PaymentStatusChip(status: booking.paymentStatus),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)
              : AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
        ),
        Text(
          value,
          style: isBold
              ? AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                )
              : AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _PaymentStatusChip extends StatelessWidget {
  final String status;

  const _PaymentStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    switch (status) {
      case 'paid':
      case 'captured':
        color = AppColors.success;
        label = 'Paid';
      case 'refunded':
        color = AppColors.info;
        label = 'Refunded';
      case 'failed':
        color = AppColors.error;
        label = 'Failed';
      default:
        color = AppColors.warning;
        label = 'Unpaid';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 4,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
