import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/string_utils.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'view_booking_info_components.dart';

class ViewBookingPaymentSummarySection extends StatelessWidget {
  final BookingEntity booking;

  const ViewBookingPaymentSummarySection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.md,
      children: [
        const ViewBookingSectionTitle(title: 'Payment Summary'),
        ViewBookingInfoCard(
          children: [
            Column(
              spacing: AppSizes.sm,
              children: [
                ViewBookingDetailRow(
                  label: 'Base Price',
                  value:
                      'Rs. ${booking.basePricePerHour.toStringAsFixed(2)}/hr',
                ),
                ViewBookingDetailRow(
                  label:
                      booking.promoCodeText != null &&
                          booking.promoCodeText!.isNotEmpty
                      ? 'Discount (${booking.promoCodeText})'
                      : 'Discount',
                  value: 'Rs. ${booking.discountAmount.toStringAsFixed(2)}',
                  valueStyle: booking.discountAmount > 0
                      ? AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        )
                      : null,
                ),
                ViewBookingDetailRow(
                  label: 'Payment Status',
                  value: StringUtils.formatSnakeCase(booking.paymentStatus),
                ),
              ],
            ),
            const Divider(height: AppSizes.xs),
            ViewBookingDetailRow(
              label: 'Total Amount',
              value: 'Rs. ${booking.totalPrice.toStringAsFixed(2)}',
              valueStyle: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }
}
