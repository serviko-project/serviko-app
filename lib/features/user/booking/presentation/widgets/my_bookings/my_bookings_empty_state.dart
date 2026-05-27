import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_tab_type.dart';

class MyBookingsEmptyState extends StatelessWidget {
  final BookingTabType tabType;
  final VoidCallback onRefresh;

  const MyBookingsEmptyState({
    super.key,
    required this.tabType,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                AppAssets.notFoundAnimation,
                width: 200,
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: AppSizes.md),

              // Title
              Text(
                'No ${tabType.label} Bookings',
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),

              // Description
              Text(
                'You don\'t have any ${tabType.label.toLowerCase()} bookings right now. Explore services and book your next appointment!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Explore Services',
                  height: 45,
                  onPressed: () {
                    context.go(RouteNames.home);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
