import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_state.dart';

import 'package:serviko_app/features/provider/onboarding/presentation/widgets/application_status/status_header_card.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/application_status/milestone_row.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/application_status/rejection_feedback_card.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/application_status/next_steps_card.dart';

class ApplicationStatusScreen extends StatelessWidget {
  const ApplicationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, RoleState>(
      builder: (context, roleState) {
        final status = roleState.providerStatus;
        final isRejected = status == ProviderStatus.rejected;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: AppColors.textPrimary,
              ),
              onPressed: () {
                context.read<RoleCubit>().switchToCustomer();
                context.goNamed(AppRouter.home);
              },
            ),
            title: Text('Application Status', style: AppTextStyles.h3),
            centerTitle: true,
          ),
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                // TODO: Implement application refresh logic
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                  vertical: AppSizes.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Header
                    StatusHeaderCard(isRejected: isRejected),

                    const SizedBox(height: AppSizes.xl),

                    // Review Milestones
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                      ),
                      child: Text(
                        'REVIEW MILESTONES',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textHint,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Milestone List
                    const MilestoneRow(
                      title: 'Profile Completed',
                      subtitle: 'Verified on April 25, 2026',
                      isCompleted: true,
                      isLast: false,
                    ),
                    const MilestoneRow(
                      title: 'Documents Uploaded',
                      subtitle: 'Verified on April 25, 2026',
                      isCompleted: true,
                      isLast: false,
                    ),

                    if (isRejected) ...[
                      const MilestoneRow(
                        title: 'Application Rejected',
                        subtitle: 'Reviewed on April 25, 2026',
                        isCompleted: false,
                        isError: true,
                        isLast: true,
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Rejection Feedback
                      const RejectionFeedbackCard(),
                    ]
                    // Not rejected, show next steps
                    else ...[
                      const MilestoneRow(
                        title: 'Admin Review',
                        subtitle: 'In progress - Estimated 24-48h',
                        isCompleted: false,
                        isActive: true,
                        isLast: false,
                      ),
                      const MilestoneRow(
                        title: 'Final Approval',
                        subtitle: 'Pending completion of review',
                        isCompleted: false,
                        isLast: true,
                      ),
                      const SizedBox(height: AppSizes.xl),
                      const NextStepsCard(),
                    ],

                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
