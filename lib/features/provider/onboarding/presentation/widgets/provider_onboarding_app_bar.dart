import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

class ProviderOnboardingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ProviderOnboardingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final stepTitles = [
      'Become a Provider',
      'Your Details',
      'Your Services',
      'Availability',
      'Upload Documents',
      'Service Area',
    ];

    return BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: AppColors.background,
          toolbarHeight: 70,
          elevation: 0,
          leading: state.currentStep < 1
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    context.read<ProviderOnboardingCubit>().previousStep();
                  },
                ),
          centerTitle: true,
          title: AnimatedSwitcher(
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
                // Step Title
                Text(
                  stepTitles[state.currentStep],
                  style: AppTextStyles.h3.copyWith(fontSize: 18),
                ),

                // Step Indicator
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
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(7),
            child: state.currentStep == 0
                ? const SizedBox.shrink()
                : TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 0, end: state.currentStep / 5),
                    builder: (context, value, _) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: AppColors.surface,
                        color: AppColors.primary,
                        minHeight: 4,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(77);
}
