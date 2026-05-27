import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_tab_type.dart';
import 'package:serviko_app/injection_container.dart';
import '../bloc/my_bookings_cubit.dart';
import '../bloc/my_bookings_state.dart';
import '../widgets/booking_card.dart';
import '../widgets/my_bookings/my_bookings_tab_bar.dart';
import '../widgets/my_bookings/my_bookings_empty_state.dart';
import '../widgets/my_bookings/my_bookings_loading_skeleton.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyBookingsCubit(
        getCustomerBookingsUseCase:
            InjectionContainer.instance.getCustomerBookingsUseCase,
      )..fetchBookings(),
      child: const MyBookingsView(),
    );
  }
}

class MyBookingsView extends StatelessWidget {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(
          title: 'My Bookings',
          leading: SizedBox.shrink(),
        ),
        body: Column(
          children: [
            const MyBookingsTabBar(),
            Expanded(
              child: BlocBuilder<MyBookingsCubit, MyBookingsState>(
                builder: (context, state) {
                  return TabBarView(
                    children: BookingTabType.values
                        .map((tab) => _buildBookingsList(context, tab, state))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(
    BuildContext context,
    BookingTabType tabType,
    MyBookingsState state,
  ) {
    if (state is MyBookingsLoading || state is MyBookingsInitial) {
      return const MyBookingsLoadingSkeleton();
    }

    if (state is MyBookingsLoaded) {
      List<BookingEntity> bookings = [];
      switch (tabType) {
        case BookingTabType.upcoming:
          bookings = state.upcomingBookings;
        case BookingTabType.completed:
          bookings = state.completedBookings;
        case BookingTabType.cancelled:
          bookings = state.cancelledBookings;
      }

      if (bookings.isEmpty) {
        return MyBookingsEmptyState(
          tabType: tabType,
          onRefresh: () async =>
              context.read<MyBookingsCubit>().fetchBookings(),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => context.read<MyBookingsCubit>().fetchBookings(),
        color: AppColors.primary,
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: bookings.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSizes.md),
          itemBuilder: (context, index) {
            return BookingCard(booking: bookings[index]);
          },
        ),
      );
    }

    if (state is MyBookingsError) {
      return CustomErrorWidget(
        message: state.message,
        onRetry: () => context.read<MyBookingsCubit>().fetchBookings(),
        isFullPage: true,
      );
    }

    return CustomErrorWidget(
      message: 'Something went wrong.',
      onRetry: () => context.read<MyBookingsCubit>().fetchBookings(),
      isFullPage: true,
    );
  }
}
