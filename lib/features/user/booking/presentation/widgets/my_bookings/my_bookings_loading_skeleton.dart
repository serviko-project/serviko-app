import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import '../booking_card.dart';

class MyBookingsLoadingSkeleton extends StatelessWidget {
  const MyBookingsLoadingSkeleton({super.key});

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
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        itemCount: 3,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSizes.md),
        itemBuilder: (context, index) {
          return BookingCard(booking: _getSkeletonBooking());
        },
      ),
    );
  }
}
