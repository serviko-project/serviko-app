import 'package:flutter/material.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit_base.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

mixin OnboardingDataMixin on ProviderOnboardingCubitBase {
  // Load categories from API
  Future<void> loadCategories() async {
    emit(state.copyWith(isCategoriesLoading: true));
    final result = await getCategoriesUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          isCategoriesLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          isCategoriesLoading: false,
          availableCategories: categories,
        ),
      ),
    );
  }

  // Load user profile for display
  Future<void> loadUserProfile() async {
    final result = await getMyProfileUseCase(const NoParams());
    result.fold(
      (_) {},
      (profile) => emit(
        state.copyWith(
          userName: profile.fullName,
          profileImageUrl: profile.profileImageUrl,
        ),
      ),
    );
  }

  // Initialize availability with default values
  void initAvailability() {
    final Map<int, DayAvailability> initialAvailability = {};
    for (int i = 1; i <= 7; i++) {
      final isEnabled = i >= 1 && i <= 5;
      initialAvailability[i] = DayAvailability(
        isEnabled: isEnabled,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
      );
    }
    emit(state.copyWith(availability: initialAvailability));
  }
}
