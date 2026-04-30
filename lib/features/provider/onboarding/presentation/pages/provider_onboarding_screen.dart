import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/availability_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/documents_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/personal_details_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/service_area_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/services_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/welcome_view.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';

class ProviderOnboardingScreen extends StatelessWidget {
  const ProviderOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProviderOnboardingCubit(),
      child: const _ProviderOnboardingView(),
    );
  }
}

class _ProviderOnboardingView extends StatelessWidget {
  const _ProviderOnboardingView();

  @override
  Widget build(BuildContext context) {
    // Titles for each onboarding step
    final stepTitles = [
      'Become a Provider',
      'Your Details',
      'Your Services',
      'Availability',
      'Upload Documents',
      'Service Area',
    ];

    return BlocListener<ProviderOnboardingCubit, ProviderOnboardingState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ProviderOnboardingStatus.success) {
          context.read<RoleCubit>().updateProviderStatus(
            ProviderStatus.pending,
          );

          context.goNamed(AppRouter.providerApplicationStatus);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Provider application submitted successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
      child: PopScope(
        canPop: context.select(
          (ProviderOnboardingCubit cubit) => cubit.state.currentStep == 0,
        ),
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final cubit = context.read<ProviderOnboardingCubit>();
          if (cubit.state.currentStep > 0) {
            cubit.previousStep();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            toolbarHeight: 70,
            elevation: 0,
            leading:
                BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
                  builder: (context, state) {
                    if (state.currentStep < 1) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {
                        context.read<ProviderOnboardingCubit>().previousStep();
                      },
                    );
                  },
                ),
            centerTitle: true,
            title:
                BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        key: ValueKey<int>(state.currentStep),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            stepTitles[state.currentStep],
                            style: AppTextStyles.h3.copyWith(fontSize: 18),
                          ),
                          if (state.currentStep > 0) ...[
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Step ${state.currentStep} of 5',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(7),
              child:
                  BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
                    builder: (context, state) {
                      if (state.currentStep == 0) {
                        return const SizedBox.shrink();
                      }

                      return TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        tween: Tween<double>(
                          begin: 0,
                          end: state.currentStep / 5,
                        ),
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            value: value,
                            backgroundColor: AppColors.surface,
                            color: AppColors.primary,
                            minHeight: 4,
                          );
                        },
                      );
                    },
                  ),
            ),
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                final cubit = context.read<ProviderOnboardingCubit>();
                return PageView(
                  controller: cubit.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    WelcomeView(),
                    PersonalDetailsView(),
                    ServicesView(),
                    AvailabilityView(),
                    DocumentsView(),
                    ServiceAreaView(),
                  ],
                );
              },
            ),
          ),

          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child:
                  BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
                    builder: (context, state) {
                      final cubit = context.read<ProviderOnboardingCubit>();
                      String buttonText = 'Continue';
                      VoidCallback? onPressed = cubit.nextStep;

                      if (state.currentStep == 0) {
                        buttonText = 'Get Started';
                      } else if (state.currentStep == 2) {
                        if (state.selectedServices.isEmpty) {
                          onPressed = null;
                        }
                      } else if (state.currentStep == 4) {
                        if (state.document1Path == null ||
                            state.document2Path == null) {
                          onPressed = null;
                        }
                      } else if (state.currentStep == 5) {
                        buttonText = 'Complete Setup';
                        onPressed =
                            state.status == ProviderOnboardingStatus.submitting
                            ? null
                            : cubit.submitOnboarding;
                      }

                      return CustomButton(
                        text: buttonText,
                        onPressed: onPressed,
                        isLoading:
                            state.status == ProviderOnboardingStatus.submitting,
                      );
                    },
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
