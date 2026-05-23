import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/view_booking/view_booking_bottom_navigation_bar.dart';
import 'package:serviko_app/features/user/payment/presentation/cubit/payment_cubit.dart';
import 'package:serviko_app/features/user/payment/presentation/cubit/payment_state.dart';
import 'package:serviko_app/injection_container.dart';
import '../bloc/view_booking_cubit.dart';
import '../bloc/view_booking_state.dart';
import '../widgets/view_booking/booking_status_banner.dart';
import '../widgets/view_booking/view_booking_header.dart';
import '../widgets/view_booking/view_booking_info_components.dart';
import '../widgets/view_booking/view_booking_location_card.dart';
import '../widgets/view_booking/view_booking_reason_card.dart';
import '../widgets/view_booking/view_booking_loading_state.dart';
import '../widgets/view_booking/view_booking_information_section.dart';
import '../widgets/view_booking/view_booking_payment_summary_section.dart';
import '../widgets/view_booking/view_booking_listener.dart';

class ViewBookingScreen extends StatelessWidget {
  final String bookingId;

  const ViewBookingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ViewBookingCubit(
            getBookingDetailUseCase:
                InjectionContainer.instance.getBookingDetailUseCase,
            cancelBookingUseCase:
                InjectionContainer.instance.cancelBookingUseCase,
            submitReviewUseCase:
                InjectionContainer.instance.submitReviewUseCase,
          )..fetchBookingDetails(bookingId),
        ),
        BlocProvider(
          create: (context) => PaymentCubit(
            createPaymentOrderUseCase:
                InjectionContainer.instance.createPaymentOrderUseCase,
            verifyPaymentUseCase:
                InjectionContainer.instance.verifyPaymentUseCase,
          ),
        ),
      ],
      child: const _ViewBookingScreenContent(),
    );
  }
}

class _ViewBookingScreenContent extends StatelessWidget {
  const _ViewBookingScreenContent();

  @override
  Widget build(BuildContext context) {
    return ViewBookingListener(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Booking Details'),
        body: BlocBuilder<ViewBookingCubit, ViewBookingState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.booking != current.booking ||
              previous.actionStatus != current.actionStatus,
          builder: (context, state) {
            if (state.status == ViewBookingStatus.loading ||
                state.status == ViewBookingStatus.initial) {
              return const ViewBookingLoadingState();
            } else if (state.status == ViewBookingStatus.error) {
              return Center(child: Text(state.message ?? 'An error occurred'));
            }

            final booking = state.booking;
            if (booking == null) return const SizedBox.shrink();

            final status = booking.status;

            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking Status Banner
                      BookingStatusBanner(status: status),

                      // Booking Details Card
                      Padding(
                        padding: const EdgeInsets.all(AppSizes.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ViewBookingHeader(booking: booking),
                            const SizedBox(height: AppSizes.xl),

                            // Information Section
                            ViewBookingInformationSection(booking: booking),
                            const SizedBox(height: AppSizes.xl),

                            // Service Location
                            const ViewBookingSectionTitle(
                              title: 'Service Location',
                            ),
                            const SizedBox(height: AppSizes.md),
                            ViewBookingLocationCard(
                              address:
                                  booking.customerAddress ??
                                  'No address provided',
                            ),

                            // Rejection/Cancellation Reason Card
                            if (booking.rejectionReason != null &&
                                booking.rejectionReason!.isNotEmpty) ...[
                              const SizedBox(height: AppSizes.xl),
                              ViewBookingSectionTitle(
                                title: status == BookingStatus.rejected
                                    ? 'Rejection Reason'
                                    : 'Cancellation Reason',
                                color: AppColors.error,
                              ),
                              const SizedBox(height: AppSizes.md),
                              ViewBookingReasonCard(
                                reason: booking.rejectionReason!,
                              ),
                            ],
                            const SizedBox(height: AppSizes.xl),

                            // Payment Summary Card
                            ViewBookingPaymentSummarySection(booking: booking),
                            const SizedBox(height: AppSizes.xxl),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.actionStatus == ViewBookingActionStatus.loading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                BlocBuilder<PaymentCubit, PaymentState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, paymentState) {
                    final isBusy =
                        paymentState.status ==
                            PaymentFlowStatus.creatingOrder ||
                        paymentState.status == PaymentFlowStatus.verifying;
                    if (!isBusy) return const SizedBox.shrink();
                    return Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: ViewBookingBottomNavigationBar(),
      ),
    );
  }
}
