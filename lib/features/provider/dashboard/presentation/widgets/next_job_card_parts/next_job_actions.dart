import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/provider/jobs/presentation/pages/provider_job_detail_screen.dart';
import 'package:serviko_app/features/provider/jobs/presentation/cubit/provider_jobs_cubit.dart';
import 'package:serviko_app/injection_container.dart';

// Bottom action bar and pricing row of next scheduled job card
class NextJobActions extends StatelessWidget {
  final BookingEntity booking;

  const NextJobActions({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // Total Price Column
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs / 2),
                Text(
                  '₹${booking.totalPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // Call Action Button
              GestureDetector(
                onTap: () async {
                  final sent = await InjectionContainer.instance.zegoService
                      .startCall(
                        contact: ProviderDirectoryEntity(
                          id: booking.customerId,
                          userId: booking.customerId,
                          firebaseUid:
                              booking.customerFirebaseUid ?? booking.customerId,
                          name: booking.customerName,
                        ),
                        isVideoCall: false,
                        customerFirebaseUid: booking.providerFirebaseUid ?? '',
                      );
                  if (!context.mounted) return;
                  if (!sent) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not start the call. Please try again.',
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCall,
                    color: AppColors.textPrimary,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),

              // View Detail Action Button
              CustomButton(
                text: 'View Details',
                width: null,
                height: 40,
                fontSize: 12,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => ProviderJobsCubit(
                          getProviderBookingsUseCase: InjectionContainer
                              .instance
                              .getProviderBookingsUseCase,
                          reviewBookingUseCase:
                              InjectionContainer.instance.reviewBookingUseCase,
                          completeBookingUseCase: InjectionContainer
                              .instance
                              .completeBookingUseCase,
                        ),
                        child: ProviderJobDetailScreen(booking: booking),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
