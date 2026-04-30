import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/injection_container.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/application_status_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/application_status_state.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_state.dart';

import 'package:serviko_app/features/provider/onboarding/presentation/widgets/application_status/status_header_card.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/application_status/milestone_row.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/application_status/rejection_feedback_card.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/application_status/next_steps_card.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

class ApplicationStatusScreen extends StatelessWidget {
  const ApplicationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApplicationStatusCubit(
        getMyProviderProfileUseCase:
            InjectionContainer.instance.getMyProviderProfileUseCase,
      )..loadStatus(),
      child: BlocListener<ApplicationStatusCubit, ApplicationStatusState>(
        listener: (context, state) {
          if (state.providerProfile != null) {
            final statusStr = state.providerProfile!.status.toLowerCase();
            final status = ProviderStatus.values.firstWhere(
              (s) => s.name.toLowerCase() == statusStr,
              orElse: () => ProviderStatus.none,
            );
            context.read<RoleCubit>().updateProviderStatus(status);
          }
        },
        child: const _ApplicationStatusView(),
      ),
    );
  }
}

class _ApplicationStatusView extends StatelessWidget {
  const _ApplicationStatusView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationStatusCubit, ApplicationStatusState>(
      builder: (context, statusState) {
        return BlocBuilder<RoleCubit, RoleState>(
          builder: (context, roleState) {
            final status = roleState.providerStatus;
            final isRejected = status == ProviderStatus.rejected;
            final isApproved = status == ProviderStatus.approved;
            final isBlocked = status == ProviderStatus.blocked;
            final profile = statusState.providerProfile;

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
                    await context.read<ApplicationStatusCubit>().loadStatus();
                  },
                  child: statusState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.screenPadding,
                            vertical: AppSizes.md,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Status Header
                              StatusHeaderCard(status: status),

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
                              MilestoneRow(
                                title: 'Profile Completed',
                                subtitle: profile?.submittedAt != null
                                    ? 'Submitted on ${DateTimeUtils.formatDate(profile!.submittedAt!)}'
                                    : 'Submitted',
                                isCompleted: true,
                                isLast: false,
                              ),
                              MilestoneRow(
                                title: 'Documents Uploaded',
                                subtitle: profile?.documents.isNotEmpty == true
                                    ? '${profile!.documents.length} document(s) uploaded'
                                    : 'Uploaded',
                                isCompleted: true,
                                isLast: false,
                              ),

                              if (isApproved) ...[
                                MilestoneRow(
                                  title: 'Final Approval',
                                  subtitle: profile?.reviewedAt != null
                                      ? 'Approved on ${DateTimeUtils.formatDate(profile!.reviewedAt!)}'
                                      : 'Approved',
                                  isCompleted: true,
                                  isLast: true,
                                ),
                                const SizedBox(height: AppSizes.xl),

                                // Go to Dashboard Button
                                CustomButton(
                                  text: 'Go to Provider Dashboard',
                                  onPressed: () {
                                    context
                                        .read<RoleCubit>()
                                        .switchToProvider();
                                    context.goNamed(
                                      AppRouter.providerDashboard,
                                    );
                                  },
                                ),
                              ] else if (isRejected) ...[
                                MilestoneRow(
                                  title: 'Application Rejected',
                                  subtitle: profile?.reviewedAt != null
                                      ? 'Reviewed on ${DateTimeUtils.formatDate(profile!.reviewedAt!)}'
                                      : 'Reviewed',
                                  isCompleted: false,
                                  isError: true,
                                  isLast: true,
                                ),
                                const SizedBox(height: AppSizes.lg),

                                // Rejection Feedback
                                RejectionFeedbackCard(
                                  reason: profile?.rejectionReason,
                                ),
                                const SizedBox(height: AppSizes.xl),
                              ] else if (isBlocked) ...[
                                MilestoneRow(
                                  title: 'Account Restricted',
                                  subtitle: profile?.reviewedAt != null
                                      ? 'Blocked on ${DateTimeUtils.formatDate(profile!.reviewedAt!)}'
                                      : 'Blocked',
                                  isCompleted: false,
                                  isError: true,
                                  isLast: true,
                                ),
                                const SizedBox(height: AppSizes.xl),

                                // Contact Support Button
                                CustomButton(
                                  text: 'Contact Support',
                                  backgroundColor: AppColors.error,
                                  onPressed: () {},
                                ),
                              ] else ...[
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
      },
    );
  }
}
