import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/booking_calendar_widget.dart';
import 'package:serviko_app/injection_container.dart';
import '../bloc/calendar_cubit.dart';
import '../bloc/calendar_state.dart';
import '../widgets/calendar_booking_card.dart';
import '../widgets/calendar_loading_skeleton.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(
        getCustomerBookingsUseCase:
            InjectionContainer.instance.getCustomerBookingsUseCase,
      )..fetchBookings(),
      child: const CalendarView(),
    );
  }
}

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'My Calendar',
        leading: SizedBox.shrink(),
      ),
      body: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          if (state is CalendarLoading || state is CalendarInitial) {
            return const CalendarLoadingSkeleton();
          }

          if (state is CalendarError) {
            return Center(child: Text(state.message));
          }

          if (state is CalendarLoaded) {
            final selectedDate = state.selectedDate;
            final bookings = state.selectedDateBookings;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar Widget
                  BookingCalendarWidget(
                    firstDay: DateTime.now().subtract(
                      const Duration(days: 365 * 5),
                    ),
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      context.read<CalendarCubit>().selectDate(date);
                    },
                    eventLoader: (day) {
                      final normalized = DateTime(day.year, day.month, day.day);
                      return state.bookingsByDate[normalized] ?? [];
                    },
                  ),
                  const SizedBox(height: AppSizes.xl),

                  // Title indicating number of bookings
                  Text(
                    'Service Booking (${bookings.length})',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppSizes.md),

                  // Bookings List or Empty State
                  if (bookings.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: AppSizes.xl),
                          Lottie.asset(
                            AppAssets.notFoundAnimation,
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: AppSizes.md),
                          Text(
                            'No bookings on this date.',
                            style: AppTextStyles.h3.copyWith(
                              letterSpacing: 0.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.xxl),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSizes.md),
                      itemBuilder: (context, index) {
                        return CalendarBookingCard(booking: bookings[index]);
                      },
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
