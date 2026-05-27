import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/provider/dashboard/presentation/widgets/sections/dashboard_overview_section.dart';
import 'package:serviko_app/features/provider/dashboard/presentation/widgets/sections/next_booking_section.dart';
import 'package:serviko_app/features/provider/dashboard/presentation/widgets/sections/pending_requests_section.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'package:serviko_app/features/provider/jobs/presentation/cubit/provider_jobs_cubit.dart';
import 'package:serviko_app/features/provider/jobs/presentation/cubit/provider_jobs_state.dart';
import '../cubit/provider_dashboard_cubit.dart';
import '../cubit/provider_dashboard_state.dart';
import '../widgets/provider_dashboard_header.dart';
import '../widgets/quick_actions_panel.dart';

// Provider Dashboard Screen
class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<ProviderDashboardCubit>().fetchDashboardStats();
    context.read<ProviderJobsCubit>().getBookings(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProviderJobsCubit, ProviderJobsState>(
          listener: (context, state) {
            if (state is ProviderJobUpdated) {
              context.read<ProviderDashboardCubit>().fetchDashboardStats();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Booking ${state.booking.status.displayLabel} successfully!',
                  ),
                  backgroundColor:
                      state.booking.status == BookingStatus.confirmed
                      ? AppColors.success
                      : AppColors.error,
                ),
              );
            }
            if (state is ProviderJobsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: BlocBuilder<ProviderDashboardCubit, ProviderDashboardState>(
              builder: (context, dashboardState) {
                return BlocBuilder<ProviderJobsCubit, ProviderJobsState>(
                  builder: (context, jobsState) {
                    // Pre-calculate variables
                    final allBookings = jobsState.bookings ?? [];
                    final pendingRequests = allBookings
                        .where((b) => b.status == BookingStatus.pending)
                        .toList();
                    final updatingId = jobsState is ProviderJobUpdating
                        ? jobsState.bookingId
                        : null;

                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        const SliverToBoxAdapter(
                          child: SizedBox(height: AppSizes.md),
                        ),

                        // Dashboard Header
                        const SliverToBoxAdapter(
                          child: ProviderDashboardHeader(),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: AppSizes.xl),
                        ),

                        // Loading state
                        if (jobsState is ProviderJobsLoading ||
                            dashboardState is ProviderDashboardLoading)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        else ...[
                          // Pending Booking Requests Carousel
                          if (pendingRequests.isNotEmpty) ...[
                            PendingRequestSection(
                              pendingRequests: pendingRequests,
                              updatingId: updatingId,
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: AppSizes.xl),
                            ),
                          ],

                          // Error state
                          if (dashboardState is ProviderDashboardError)
                            SliverToBoxAdapter(
                              child: Center(
                                child: CustomErrorWidget(
                                  message: dashboardState.message,
                                  onRetry: _loadData,
                                ),
                              ),
                            )
                          // Dashboard Overview Section
                          else if (dashboardState
                              is ProviderDashboardLoaded) ...[
                            DashboardOverviewSection(
                              dashboardState: dashboardState,
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: AppSizes.xl),
                            ),

                            // Next Booking Section
                            NextBookingSection(dashboardState: dashboardState),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: AppSizes.xl),
                            ),

                            // Quick Actions Section
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.md,
                                ),
                                child: QuickActionsPanel(),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: AppSizes.xxl),
                            ),
                          ],
                        ],
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
