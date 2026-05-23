import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_actions.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_details.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_header.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_price.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/job_card_parts/job_card_timer.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

const int kBookingExpirationHours = 3;

class JobCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback? onTap;
  final bool isUpdating;

  const JobCard({
    super.key,
    required this.booking,
    required this.onAccept,
    required this.onReject,
    this.onTap,
    this.isUpdating = false,
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
    final isPending = booking.status == BookingStatus.pending;

    if (isPending) {
      return StreamBuilder<int>(
        stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
        builder: (context, _) {
          final timeLeft = _computeRemaining();
          final isExpired = timeLeft == Duration.zero;
          final status = isExpired ? BookingStatus.expired : booking.status;

          return _buildCardFrame(
            context,
            statusColor: status.color,
            child: _PendingJobCardContent(
              booking: booking,
              status: status,
              timeLeft: timeLeft,
              onAccept: onAccept,
              onReject: onReject,
              isUpdating: isUpdating,
            ),
          );
        },
      );
    }

    return _buildCardFrame(
      context,
      statusColor: booking.status.color,
      child: _StaticJobCardContent(booking: booking),
    );
  }

  Widget _buildCardFrame(
    BuildContext context, {
    required Color statusColor,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          border: Border(left: BorderSide(color: statusColor, width: 5)),
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
              Padding(padding: const EdgeInsets.all(AppSizes.md), child: child),
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
      ),
    );
  }
}

// Content for non-actionable cards (completed, rejected, cancelled, expired, confirmed)
class _StaticJobCardContent extends StatelessWidget {
  final BookingEntity booking;

  const _StaticJobCardContent({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JobCardHeader(booking: booking, status: booking.status),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.sm + 4),
          child: Divider(height: 1),
        ),
        JobCardDetails(booking: booking),
        const SizedBox(height: AppSizes.sm + 4),
        JobCardPrice(booking: booking),
      ],
    );
  }
}

// Content for Pending cards with timer + accept/reject
class _PendingJobCardContent extends StatelessWidget {
  final BookingEntity booking;
  final BookingStatus status;
  final Duration timeLeft;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isUpdating;

  const _PendingJobCardContent({
    required this.booking,
    required this.status,
    required this.timeLeft,
    required this.onAccept,
    required this.onReject,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired = timeLeft == Duration.zero;

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
      ],
    );
  }
}
