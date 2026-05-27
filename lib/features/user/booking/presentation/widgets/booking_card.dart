import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'booking_card_parts/booking_card_header.dart';
import 'booking_card_parts/booking_card_info.dart';
import 'booking_card_parts/booking_card_rejection_alert.dart';
import 'booking_card_parts/booking_card_actions.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = booking.status;

    final hasRejectionReason =
        (status == BookingStatus.rejected ||
            status == BookingStatus.cancelled) &&
        booking.rejectionReason != null &&
        booking.rejectionReason!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          onTap: () {
            context.pushNamed(
              RouteNames.viewBooking,
              pathParameters: {'id': booking.id},
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Booking Header with Provider Info and Status
                BookingCardHeader(
                  providerImage: booking.providerImage,
                  providerName: booking.providerName,
                  categoryName: booking.categoryName,
                  status: status,
                ),
                const SizedBox(height: AppSizes.md),

                // Booking Info
                BookingCardInfo(
                  date: DateTimeUtils.formatToUppercaseCustomDate(
                    booking.scheduledDate,
                  ),
                  timeRange:
                      '${DateTimeUtils.formatTo12Hour(booking.startTime)} - ${DateTimeUtils.formatTo12Hour(booking.endTime)}',
                  totalFormatted: '₹${booking.totalPrice.toStringAsFixed(2)}',
                ),

                // Rejection/Cancellation Reason Alert
                if (hasRejectionReason) ...[
                  const SizedBox(height: AppSizes.md),
                  BookingCardRejectionAlert(
                    status: status,
                    reason: booking.rejectionReason!,
                  ),
                ],
                const SizedBox(height: AppSizes.md),
                BookingCardActions(
                  status: status,
                  paymentStatus: booking.paymentStatus,
                  bookingId: booking.id,
                  serviceId: booking.serviceId,
                  hasReview: booking.hasReview,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
