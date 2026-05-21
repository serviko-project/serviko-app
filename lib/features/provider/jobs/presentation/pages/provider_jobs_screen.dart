import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import '../cubit/provider_jobs_cubit.dart';
import '../cubit/provider_jobs_state.dart';
import '../widgets/provider_jobs_app_bar.dart';
import '../widgets/provider_jobs_tab_page.dart';

class ProviderJobsScreen extends StatefulWidget {
  const ProviderJobsScreen({super.key});

  @override
  State<ProviderJobsScreen> createState() => _ProviderJobsScreenState();
}

class _ProviderJobsScreenState extends State<ProviderJobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _statuses = [
    'all',
    'pending',
    'confirmed',
    'completed',
    'rejected',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderJobsCubit>().getBookings(refresh: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProviderJobsCubit, ProviderJobsState>(
      listener: (context, state) {
        if (state is ProviderJobsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
        if (state is ProviderJobUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Booking ${state.booking.status.displayLabel} successfully!',
              ),
              backgroundColor: state.booking.status == BookingStatus.confirmed
                  ? AppColors.success
                  : AppColors.warning,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ProviderJobsAppBar(
          tabController: _tabController,
          statuses: _statuses,
        ),
        body: TabBarView(
          controller: _tabController,
          children: _statuses.map((status) {
            final statusFilter = status == 'all' ? null : status;
            return ProviderJobsTabPage(statusFilter: statusFilter);
          }).toList(),
        ),
      ),
    );
  }
}
