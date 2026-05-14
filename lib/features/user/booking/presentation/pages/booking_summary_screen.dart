import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_request_payload.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/booking_summary_cubit.dart';
import 'package:serviko_app/injection_container.dart';
import '../widgets/summary_provider_header.dart';
import '../widgets/summary_details_card.dart';
import '../widgets/summary_price_card.dart';

class BookingSummaryScreen extends StatelessWidget {
  final BookingRequestPayload payload;

  const BookingSummaryScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingSummaryCubit(
        createBookingUseCase: InjectionContainer.instance.createBookingUseCase,
      ),
      child: BlocConsumer<BookingSummaryCubit, BookingSummaryState>(
        listener: (context, state) {
          if (state.status == BookingSummaryStatus.success) {
            context.pushNamed(RouteNames.bookingSuccess);
          }
          if (state.status == BookingSummaryStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Booking failed'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: const CustomAppBar(title: "Booking Summary"),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SummaryProviderHeader(payload: payload),
                  const SizedBox(height: AppSizes.lg),
                  _buildSectionTitle("Booking Details"),
                  const SizedBox(height: AppSizes.sm),
                  SummaryDetailsCard(payload: payload),
                  const SizedBox(height: AppSizes.lg),
                  _buildSectionTitle("Price Summary"),
                  const SizedBox(height: AppSizes.sm),
                  SummaryPriceCard(payload: payload),
                  const SizedBox(height: AppSizes.xl * 2),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: CustomButton(
                  text: "Confirm Booking",
                  isLoading: state.status == BookingSummaryStatus.submitting,
                  onPressed: state.status == BookingSummaryStatus.submitting
                      ? null
                      : () {
                          context.read<BookingSummaryCubit>().submitBooking(
                            payload,
                          );
                        },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
