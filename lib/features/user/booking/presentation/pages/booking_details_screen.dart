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
import 'package:serviko_app/features/user/booking/presentation/widgets/time_slots_error_widget.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/time_slots_warning_widget.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/working_hours_widget.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_request_payload.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_init_data.dart';
import 'package:serviko_app/injection_container.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/booking_promos_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/promo_list_bottom_sheet.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingInitData initData;
  const BookingDetailsScreen({super.key, required this.initData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingDetailsCubit(
        getAvailableSlotsUseCase:
            InjectionContainer.instance.getAvailableSlotsUseCase,
        providerId: initData.providerId,
        initialBasePrice: initData.basePricePerHour,
      ),
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
                  if (state.selectedStartTime.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.xs),
                    // Time Slot Conflict Warning
                    Text(
                      'Max duration for this slot: ${state.maxBookableHours} hours',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: state.hasConflict
                            ? AppColors.error
                            : AppColors.textPrimary,
                        fontWeight: state.hasConflict ? FontWeight.bold : null,
                      ),
                    ),
                  ],
                  if (state.hasConflict) ...[
                    const SizedBox(height: AppSizes.sm),
                    TimeSlotsErrorWidget(),
                  ],
                  const SizedBox(height: AppSizes.xl),

                  // Start Time Slots
                  if (state.status == BookingDetailsStatus.loading)
                    Skeletonizer(child: StartTimeSlotsWidget.shimmer())
                  else if (state.status == BookingDetailsStatus.failure)
                    Center(
                      child: Text(
                        state.errorMessage ?? 'Failed to load slots',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  else if (state.availableStartTimes.isEmpty)
                    TimeSlotsWarningWidget()
                  else
                    StartTimeSlotsWidget(
                      timeSlots: state.availableStartTimes,
                      selectedTime: state.selectedStartTime,
                      onTimeSelected: (time) {
                        context.read<BookingDetailsCubit>().selectStartTime(
                          time,
                        );
                      },
                    ),
                  const SizedBox(height: AppSizes.xl),

                  // Promo Code Selector
                  PromoCodeWidget(
                    selectedPromo: state.appliedPromo?.code ?? '',
                    onRemove: () {
                      context.read<BookingDetailsCubit>().updatePromoCode(null);
                    },
                    onTap: () async {
                      final selectedPromo =
                          await showModalBottomSheet<PromoCode>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return BlocProvider(
                                create: (context) => BookingPromosCubit(
                                  getProviderPromosUseCase: InjectionContainer
                                      .instance
                                      .getProviderPromosUseCase,
                                )..loadPromos(initData.providerId),
                                child: const PromoListBottomSheet(),
                              );
                            },
                          );

                      if (selectedPromo != null && context.mounted) {
                        final minAmount = selectedPromo.minBookingAmount ?? 0.0;
                        if (minAmount > 0 && state.subTotal < minAmount) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Minimum booking amount of ₹${minAmount.toStringAsFixed(0)} required for this promo.',
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        } else {
                          context.read<BookingDetailsCubit>().updatePromoCode(
                            selectedPromo,
                          );
                        }
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
                  isEnabled: state.canContinue,
                  onContinue: () {
                    final payload = BookingRequestPayload(
                      initData: initData,
                      selectedDate: state.selectedDate,
                      workingHours: state.workingHours,
                      selectedStartTime: state.selectedStartTime,
                      promoCode: state.appliedPromo?.code ?? '',
                      totalPrice: state.totalPrice,
                    );
                    context.pushNamed(
                      RouteNames.bookingLocation,
                      extra: payload,
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}
