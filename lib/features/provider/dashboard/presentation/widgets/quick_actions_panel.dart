import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_cubit.dart';

// Quick Action Shortcuts Panel
class QuickActionsPanel extends StatelessWidget {
  const QuickActionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          crossAxisSpacing: AppSizes.xs,
          mainAxisSpacing: AppSizes.md,
          children: [
            _buildActionItem(
              context,
              title: 'Promo Codes',
              icon: HugeIcons.strokeRoundedTicket01,
              color: AppColors.primary,
              bgColor: AppColors.primary.withValues(alpha: 0.1),
              onTap: () => context.pushNamed(RouteNames.providerPromoCodes),
            ),
            _buildActionItem(
              context,
              title: 'Edit Details',
              icon: HugeIcons.strokeRoundedUserEdit01,
              color: AppColors.info,
              bgColor: AppColors.info.withValues(alpha: 0.1),
              onTap: () => context.pushNamed(
                RouteNames.providerEditDetails,
                extra: context.read<ProviderProfileCubit>(),
              ),
            ),
            _buildActionItem(
              context,
              title: 'My Earnings',
              icon: HugeIcons.strokeRoundedMoney03,
              color: AppColors.success,
              bgColor: AppColors.success.withValues(alpha: 0.1),
              onTap: () => context.go(RoutePaths.providerEarnings),
            ),
            _buildActionItem(
              context,
              title: 'View Jobs',
              icon: HugeIcons.strokeRoundedBriefcase01,
              color: AppColors.primaryLight,
              bgColor: AppColors.primaryLight.withValues(alpha: 0.1),
              onTap: () => context.go(RoutePaths.providerJobs),
            ),
            _buildActionItem(
              context,
              title: 'My Reviews',
              icon: HugeIcons.strokeRoundedStar,
              color: AppColors.warning,
              bgColor: AppColors.warning.withValues(alpha: 0.1),
              onTap: () => context.pushNamed(
                RouteNames.providerReviews,
                extra: context.read<ProviderProfileCubit>(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required String title,
    required List<List<dynamic>> icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Center(
              child: HugeIcon(icon: icon, color: color, size: 24),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
