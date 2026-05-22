import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import '../cubit/provider_jobs_cubit.dart';
import '../cubit/provider_jobs_state.dart';
import '../pages/provider_job_detail_screen.dart';
import 'job_card.dart';
import 'rejection_dialog.dart';

class JobsListView extends StatelessWidget {
  final List<BookingEntity> bookings;
  final ProviderJobsState state;
  final String? currentStatus;

  const JobsListView({
    super.key,
    required this.bookings,
    required this.state,
    this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ProviderJobsCubit>().getBookings(refresh: true);
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount:
            bookings.length +
            (state is ProviderJobsLoaded &&
                    !(state as ProviderJobsLoaded).hasReachedMax
                ? 1
                : 0),
        itemBuilder: (context, index) {
          if (index >= bookings.length) {
            context.read<ProviderJobsCubit>().getBookings();
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.sm),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final booking = bookings[index];
          return JobCard(
            booking: booking,
            isUpdating:
                state is ProviderJobUpdating &&
                (state as ProviderJobUpdating).bookingId == booking.id,
            onAccept: () {
              context.read<ProviderJobsCubit>().reviewBooking(
                bookingId: booking.id,
                action: 'confirm',
              );
            },
            onReject: () => showRejectionDialog(context, booking.id),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProviderJobsCubit>(),
                    child: ProviderJobDetailScreen(booking: booking),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
