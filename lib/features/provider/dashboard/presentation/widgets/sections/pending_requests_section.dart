import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/provider/dashboard/presentation/widgets/pending_requests_carousel.dart';
import 'package:serviko_app/features/provider/jobs/presentation/cubit/provider_jobs_cubit.dart';
import 'package:serviko_app/features/provider/jobs/presentation/widgets/rejection_dialog.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

// Section displaying pending booking requests on the provider dashboard
class PendingRequestSection extends StatelessWidget {
  const PendingRequestSection({
    super.key,
    required this.pendingRequests,
    required this.updatingId,
  });

  final List<BookingEntity> pendingRequests;
  final String? updatingId;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
        child: PendingRequestsCarousel(
          requests: pendingRequests,
          updatingBookingId: updatingId,
          onAccept: (bookingId) {
            context.read<ProviderJobsCubit>().reviewBooking(
              bookingId: bookingId,
              action: 'confirm',
            );
          },
          onReject: (bookingId) => showRejectionDialog(context, bookingId),
        ),
      ),
    );
  }
}
