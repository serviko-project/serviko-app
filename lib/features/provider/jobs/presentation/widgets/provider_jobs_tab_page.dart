import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import '../cubit/provider_jobs_cubit.dart';
import '../cubit/provider_jobs_state.dart';
import 'jobs_list_view.dart';
import 'provider_jobs_empty_state.dart';

class ProviderJobsTabPage extends StatelessWidget {
  final String? statusFilter;

  const ProviderJobsTabPage({super.key, required this.statusFilter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderJobsCubit, ProviderJobsState>(
      builder: (context, state) {
        if (state is ProviderJobsLoading && (state.bookings?.isEmpty ?? true)) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProviderJobsError && state.bookings == null) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () =>
                context.read<ProviderJobsCubit>().getBookings(refresh: true),
          );
        }

        final allBookings = state.bookings ?? [];
        final bookings = _filterByStatus(allBookings);

        if (bookings.isEmpty && state is ProviderJobsLoaded) {
          return const ProviderJobsEmptyState();
        }

        return JobsListView(
          bookings: bookings,
          state: state,
          currentStatus: statusFilter,
        );
      },
    );
  }

  List<BookingEntity> _filterByStatus(List<BookingEntity> bookings) {
    if (statusFilter == null) return bookings;
    return bookings.where((b) => b.status.value == statusFilter).toList();
  }
}
