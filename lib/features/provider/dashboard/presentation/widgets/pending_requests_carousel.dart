import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

// Pending Booking Requests Carousel
class PendingRequestsCarousel extends StatelessWidget {
  final List<BookingEntity> requests;
  final String? updatingBookingId;
  final Function(String bookingId) onAccept;
  final Function(String bookingId) onReject;

  const PendingRequestsCarousel({
    super.key,
    required this.requests,
    this.updatingBookingId,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Section Title with Count Badge
            Text(
              'Booking Requests',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs / 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
              ),
              child: Text(
                requests.length.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm + AppSizes.xs),

        // Horizontal List of Pending Requests
        SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final booking = requests[index];
              final isUpdating = booking.id == updatingBookingId;

              return Container(
                key: ValueKey(booking.id),
                width: MediaQuery.of(context).size.width * 0.85,
                margin: const EdgeInsets.only(
                  right: AppSizes.md,
                  bottom: AppSizes.xs,
                ),
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer & category info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.surface,
                          backgroundImage: booking.customerImage != null
                              ? NetworkImage(booking.customerImage!)
                              : null,
                          child: booking.customerImage == null
                              ? HugeIcon(
                                  icon: HugeIcons.strokeRoundedUser03,
                                  color: AppColors.textSecondary,
                                  size: 15,
                                )
                              : null,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.customerName ?? 'Customer',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                booking.categoryName ?? 'Service',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${booking.totalPrice.toStringAsFixed(0)}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    // Date & Time
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedCalendar03,
                          size: 15,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSizes.xs + 2),
                        (() {
                          final dateStr = DateTimeUtils.formatToReadableDate(
                            booking.scheduledDate,
                          );
                          final startTimeStr = DateTimeUtils.formatTo12Hour(
                            booking.startTime,
                          );

                          return Text(
                            '$dateStr  •  $startTimeStr',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }()),
                      ],
                    ),
                    const Spacer(),
                    // Accept / Decline buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Decline',
                            isOutlined: true,
                            height: 36,
                            fontSize: 12,
                            borderColor: isUpdating
                                ? AppColors.border
                                : AppColors.error,
                            textColor: isUpdating
                                ? AppColors.textSecondary
                                : AppColors.error,
                            onPressed: isUpdating
                                ? null
                                : () => onReject(booking.id),
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm + AppSizes.xs),
                        Expanded(
                          child: CustomButton(
                            text: 'Accept',
                            isLoading: isUpdating,
                            height: 36,
                            fontSize: 12,
                            backgroundColor: isUpdating
                                ? AppColors.border
                                : AppColors.primary,
                            onPressed: isUpdating
                                ? null
                                : () => onAccept(booking.id),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
