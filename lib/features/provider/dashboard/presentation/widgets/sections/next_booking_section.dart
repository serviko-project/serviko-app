import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/dashboard/presentation/cubit/provider_dashboard_state.dart';
import 'package:serviko_app/features/provider/dashboard/presentation/widgets/next_job_card_parts/next_job_card.dart';

class NextBookingSection extends StatelessWidget {
  final ProviderDashboardLoaded dashboardState;

  const NextBookingSection({super.key, required this.dashboardState});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Text(
              'Next Booking',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.sm + AppSizes.xs),
        ),

        // Job Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: NextJobCard(booking: dashboardState.stats.nextJob),
          ),
        ),
      ],
    );
  }
}
