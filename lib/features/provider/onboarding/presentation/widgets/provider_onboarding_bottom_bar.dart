import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

class ProviderOnboardingBottomBar extends StatelessWidget {
  const ProviderOnboardingBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
          builder: (context, state) {
            if (state.status == ProviderOnboardingStatus.loading) {
              return const SizedBox.shrink();
            }

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
              if (state.governmentIdDoc == null ||
                  state.certificateDoc == null) {
                onPressed = null;
              }
            } else if (state.currentStep == 5) {
              buttonText = 'Complete Setup';
              onPressed = state.status == ProviderOnboardingStatus.submitting
                  ? null
                  : cubit.submitOnboarding;
            }

            return CustomButton(
              text: buttonText,
              onPressed: onPressed,
              isLoading: state.status == ProviderOnboardingStatus.submitting,
            );
          },
        ),
      ),
    );
  }
}
