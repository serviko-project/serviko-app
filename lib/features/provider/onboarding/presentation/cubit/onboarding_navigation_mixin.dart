import 'package:flutter/material.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit_base.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

mixin OnboardingNavigationMixin on ProviderOnboardingCubitBase {
  void nextStep() {
    if (state.currentStep == 1 &&
        !(formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (state.currentStep == 2 && state.selectedServices.isEmpty) {
      emit(
        state.copyWith(
          status: ProviderOnboardingStatus.error,
          errorMessage: 'Please select at least one service category.',
        ),
      );
      return;
    }
    if (state.currentStep == 2) {
      final allPriced = state.selectedServices.every(
        (id) => (state.categoryPrices[id] ?? 0) > 0,
      );
      if (!allPriced) {
        emit(
          state.copyWith(
            showPriceValidation: true,
            status: ProviderOnboardingStatus.error,
            errorMessage:
                'Please set an hourly rate for all selected services.',
          ),
        );
        return;
      }
    }
    if (state.currentStep == 4) {
      if (state.governmentIdDoc == null || state.certificateDoc == null) return;
    }

    if (state.currentStep < 5) {
      final next = state.currentStep + 1;
      emit(state.copyWith(currentStep: next));
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      final prev = state.currentStep - 1;
      emit(state.copyWith(currentStep: prev));
      pageController.animateToPage(
        prev,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
