import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/booking_details_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/booking_details_state.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/booking_calendar_widget.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/booking_bottom_bar.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/promo_code_widget.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/start_time_slots_widget.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/working_hours_widget.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:go_router/go_router.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  static const List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingDetailsCubit(initialBasePrice: 100),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: "Booking Details"),
        body: BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Date', style: AppTextStyles.h3),
                  const SizedBox(height: AppSizes.md),

                  // Calendar Widget
                  BookingCalendarWidget(
                    selectedDate: state.selectedDate,
                    onDateSelected: (date) {
                      context.read<BookingDetailsCubit>().selectDate(date);
                    },
                  ),
                  const SizedBox(height: AppSizes.xl),

                  // Working Hours Selector
                  WorkingHoursWidget(
                    workingHours: state.workingHours,
                    onIncrement: () =>
                        context.read<BookingDetailsCubit>().incrementHours(),
                    onDecrement: () =>
                        context.read<BookingDetailsCubit>().decrementHours(),
                  ),
                  const SizedBox(height: AppSizes.xl),

                  // Start Time Slots
                  StartTimeSlotsWidget(
                    timeSlots: _timeSlots,
                    selectedTime: state.selectedStartTime,
                    onTimeSelected: (time) {
                      context.read<BookingDetailsCubit>().selectStartTime(time);
                    },
                  ),
                  const SizedBox(height: AppSizes.xl),

                  // Promo Code Selector
                  PromoCodeWidget(
                    selectedPromo: state.promoCode,
                    onTap: () async {
                      final selectedPromo = await context.pushNamed<String>(
                        RouteNames.promoSelection,
                      );
                      if (selectedPromo != null && context.mounted) {
                        context.read<BookingDetailsCubit>().updatePromoCode(
                          selectedPromo,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppSizes.xxl),
                ],
              ),
            );
          },
        ),
        // Continue Button with price summary
        bottomNavigationBar:
            BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
              builder: (context, state) {
                return BookingBottomBar(
                  price: state.totalPrice,
                  onContinue: () {
                    context.pushNamed(RouteNames.bookingLocation);
                  },
                );
              },
            ),
      ),
    );
  }
}
