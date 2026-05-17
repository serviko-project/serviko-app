import 'package:flutter/material.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'calendar_booking_card.dart';

class CalendarLoadingSkeleton extends StatelessWidget {
  const CalendarLoadingSkeleton({super.key});

  BookingEntity _getSkeletonBooking() {
    final now = DateTime.now();
    return BookingEntity(
      id: 'id',
      customerId: 'customerId',
      providerId: 'providerId',
      serviceId: 'serviceId',
      scheduledDate: '2026-01-01',
      startTime: '10:00 AM',
      endTime: '12:00 PM',
      durationHours: 2,
      basePricePerHour: 10.0,
      totalPrice: 10.0,
      status: BookingStatus.confirmed,
      providerName: 'Provider Name',
      categoryName: 'Category Name',
      createdAt: now.toIso8601String(),
      updatedAt: now.toIso8601String(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Placeholder
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                color: AppColors.shimmerHighlight,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              padding: const EdgeInsets.all(AppSizes.sm),
            ),
            const SizedBox(height: AppSizes.xl),

            // Title
            Text('Service Booking (0)', style: AppTextStyles.h3),
            const SizedBox(height: AppSizes.md),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.md),
              itemBuilder: (context, index) {
                return CalendarBookingCard(booking: _getSkeletonBooking());
              },
            ),
          ],
        ),
      ),
    );
  }
}
