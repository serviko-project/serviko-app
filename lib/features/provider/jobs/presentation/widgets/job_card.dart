import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_actions.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_details.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_header.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_price.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_status_footers.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_timer.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

const int kBookingExpirationHours = 3;

class JobCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isUpdating;

  const JobCard({
    super.key,
    required this.booking,
    required this.onAccept,
    required this.onReject,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = booking.status == BookingStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: isPending
                  ? _PendingJobCardContent(
                      booking: booking,
                      onAccept: onAccept,
                      onReject: onReject,
                      isUpdating: isUpdating,
                    )
                  : _StaticJobCardContent(booking: booking),
            ),
            if (isUpdating)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Content for Pending Jobs without Timer
class _StaticJobCardContent extends StatelessWidget {
  final BookingEntity booking;

  const _StaticJobCardContent({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Jobs Card Header
        JobCardHeader(booking: booking, status: booking.status),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.sm + 4),
          child: Divider(height: 1),
        ),
        // Job Card Details
        JobCardDetails(booking: booking),
        const SizedBox(height: AppSizes.sm + 4),

        // Job Card Price
        JobCardPrice(booking: booking),

        // Rejection Reason
        if (booking.status == BookingStatus.rejected) ...[
          const SizedBox(height: AppSizes.sm + 4),
          JobCardRejectionFooter(
            reason: booking.rejectionReason ?? 'No reason provided',
          ),
        ],
      ],
    );
  }
}

// Content for Pending cards
class _PendingJobCardContent extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isUpdating;

  const _PendingJobCardContent({
    required this.booking,
    required this.onAccept,
    required this.onReject,
    required this.isUpdating,
  });

  Duration _computeRemaining() {
    try {
      final createdAt = DateTime.parse(booking.createdAt).toLocal();
      final expiry = createdAt.add(
        const Duration(hours: kBookingExpirationHours),
      );
      final remaining = expiry.difference(DateTime.now());
      return remaining.isNegative ? Duration.zero : remaining;
    } catch (_) {
      return Duration.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
      builder: (context, _) {
        final timeLeft = _computeRemaining();
        final isExpired = timeLeft == Duration.zero;
        final status = isExpired ? BookingStatus.expired : booking.status;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobCardHeader(booking: booking, status: status),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.sm + 4),
              child: Divider(height: 1),
            ),
            JobCardDetails(booking: booking),
            const SizedBox(height: AppSizes.sm + 4),
            JobCardPrice(booking: booking),
            if (!isExpired) ...[
              const SizedBox(height: AppSizes.sm + 4),
              JobCardTimer(timeLeft: timeLeft),
              const SizedBox(height: AppSizes.md),
              JobCardActions(
                onAccept: onAccept,
                onReject: onReject,
                isUpdating: isUpdating,
              ),
            ],
            if (isExpired) ...[
              const SizedBox(height: AppSizes.md),
              const JobCardExpiredFooter(),
            ],
          ],
        );
      },
    );
  }
}
