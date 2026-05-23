import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/view_booking/booking_status_banner.dart';
import '../cubit/provider_jobs_cubit.dart';
import '../cubit/provider_jobs_state.dart';
import '../widgets/completion_dialog.dart';
import '../widgets/job_detail_parts/customer_info_card.dart';
import '../widgets/job_detail_parts/job_info_section.dart';
import '../widgets/job_detail_parts/location_section.dart';
import '../widgets/job_detail_parts/payment_section.dart';
import '../widgets/job_detail_parts/completion_note_section.dart';
import '../widgets/job_detail_parts/reason_section.dart';

// Provider-Side job detail screen
class ProviderJobDetailScreen extends StatelessWidget {
  final BookingEntity booking;

  const ProviderJobDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderJobsCubit, ProviderJobsState>(
      listener: (context, state) {
        if (state is ProviderJobUpdated && state.booking.id == booking.id) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Job ${state.booking.status.displayLabel} successfully!',
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
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
      builder: (context, state) {
        final current =
            state.bookings?.cast<BookingEntity>().firstWhere(
              (b) => b.id == booking.id,
              orElse: () => booking,
            ) ??
            booking;

        final isUpdating =
            state is ProviderJobUpdating && state.bookingId == current.id;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: 'Job Details'),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking status banner
                    BookingStatusBanner(status: current.status),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer info
                          CustomerInfoCard(booking: current),
                          const SizedBox(height: AppSizes.lg),

                          // Job details
                          JobInfoSection(booking: current),
                          const SizedBox(height: AppSizes.lg),

                          // Location details
                          LocationSection(booking: current),
                          const SizedBox(height: AppSizes.lg),

                          // Payment details
                          PaymentSection(booking: current),

                          // Completion note
                          if (current.status == BookingStatus.completed &&
                              current.completionNote != null &&
                              current.completionNote!.isNotEmpty) ...[
                            const SizedBox(height: AppSizes.lg),
                            CompletionNoteSection(
                              note: current.completionNote!,
                            ),
                          ],

                          // Rejection reason
                          if (current.rejectionReason != null &&
                              current.rejectionReason!.isNotEmpty) ...[
                            const SizedBox(height: AppSizes.lg),
                            ReasonSection(
                              title: current.status == BookingStatus.rejected
                                  ? 'Rejection Reason'
                                  : 'Cancellation Reason',
                              reason: current.rejectionReason!,
                            ),
                          ],

                          const SizedBox(height: AppSizes.xxl),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isUpdating)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, current, isUpdating),
        );
      },
    );
  }

  Widget? _buildBottomBar(
    BuildContext context,
    BookingEntity current,
    bool isUpdating,
  ) {
    // Show Mark Complete button for confirmed + paid bookings
    if (current.status == BookingStatus.confirmed &&
        (current.paymentStatus == 'paid' ||
            current.paymentStatus == 'captured')) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: CustomButton(
            text: 'Mark as Completed',
            onPressed: isUpdating
                ? null
                : () => showCompletionDialog(context, current.id, (id, note) {
                    context.read<ProviderJobsCubit>().completeBooking(
                      bookingId: id,
                      completionNote: note,
                    );
                  }),
            backgroundColor: AppColors.success,
            textColor: Colors.white,
            borderRadius: AppSizes.radiusMd,
            icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          ),
        ),
      );
    }
    return null;
  }
}
