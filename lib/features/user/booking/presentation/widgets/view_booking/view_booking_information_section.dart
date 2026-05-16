import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'view_booking_info_components.dart';

class ViewBookingInformationSection extends StatelessWidget {
  final BookingEntity booking;

  const ViewBookingInformationSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ViewBookingSectionTitle(title: 'Booking Information'),
        const SizedBox(height: AppSizes.md),
        // Booking Details
        ViewBookingInfoCard(
          children: [
            // Booking ID
            ViewBookingDetailRow(
              label: 'Booking ID',
              value:
                  '#${booking.id.length > 8 ? booking.id.substring(0, 8).toUpperCase() : booking.id.toUpperCase()}',
              isBold: true,
            ),

            // Date
            ViewBookingDetailRow(label: 'Date', value: booking.scheduledDate),

            // Time Slot
            ViewBookingDetailRow(
              label: 'Time Slot',
              value:
                  '${DateTimeUtils.formatTo12Hour(booking.startTime)} - ${DateTimeUtils.formatTo12Hour(booking.endTime)}',
            ),

            // Duration
            ViewBookingDetailRow(
              label: 'Duration',
              value:
                  '${booking.durationHours} ${booking.durationHours > 1 ? 'hours' : 'hour'}',
            ),

            // Booked On
            ViewBookingDetailRow(
              label: 'Booked On',
              value: DateFormat(
                'dd MMM yyyy',
              ).format(DateTime.parse(booking.createdAt)),
            ),
          ],
        ),
      ],
    );
  }
}
