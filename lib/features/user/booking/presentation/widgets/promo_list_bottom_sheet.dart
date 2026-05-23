import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/booking_promos_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/booking_promos_state.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/promo_details_widget.dart';

class PromoListBottomSheet extends StatelessWidget {
  const PromoListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSizes.md),
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Header with Close Button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Available Offers", style: AppTextStyles.h3),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          const Divider(),

          // Promo List
          Flexible(
            child: BlocBuilder<BookingPromosCubit, BookingPromosState>(
              builder: (context, state) {
                if (state.status == BookingPromosStatus.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSizes.xl),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    ),
                  );
                } else if (state.status == BookingPromosStatus.failure) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSizes.xl),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.errorMessage ?? "Failed to load offers",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state.status == BookingPromosStatus.success) {
                  if (state.promos.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_offer_outlined,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: AppSizes.sm),
                              Text(
                                "No offers available at the moment.",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  // Display list of promos
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(AppSizes.screenPadding),
                    itemCount: state.promos.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSizes.md),
                    itemBuilder: (context, index) {
                      final promo = state.promos[index];
                      return PromoDetailsWidget(promo: promo);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }
}
