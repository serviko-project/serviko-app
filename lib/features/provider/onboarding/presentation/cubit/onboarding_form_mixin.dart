import 'package:flutter/material.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit_base.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

mixin OnboardingFormMixin on ProviderOnboardingCubitBase {
  // Update form fields in state
  void setYearsOfExperience(int years) {
    if (years >= 0 && years <= 50) {
      emit(state.copyWith(yearsOfExperience: years));
    }
  }

  void toggleService(String serviceId) {
    final updatedServices = Set<String>.from(state.selectedServices);
    final updatedPrices = Map<String, double>.from(state.categoryPrices);
    if (updatedServices.contains(serviceId)) {
      updatedServices.remove(serviceId);
      updatedPrices.remove(serviceId);
    } else {
      updatedServices.add(serviceId);
    }
    emit(
      state.copyWith(
        selectedServices: updatedServices,
        categoryPrices: updatedPrices,
        showPriceValidation: false,
      ),
    );
  }

  void updateCategoryPrice(String categoryId, double price) {
    final updatedPrices = Map<String, double>.from(state.categoryPrices);
    updatedPrices[categoryId] = price;
    emit(
      state.copyWith(categoryPrices: updatedPrices, showPriceValidation: false),
    );
  }

  void toggleDay(int dayOfWeek) {
    final currentDay = state.availability[dayOfWeek]!;
    final updatedAvailability = Map<int, DayAvailability>.from(
      state.availability,
    );
    updatedAvailability[dayOfWeek] = currentDay.copyWith(
      isEnabled: !currentDay.isEnabled,
    );
    emit(state.copyWith(availability: updatedAvailability));
  }

  void setTimeForDay(
    int dayOfWeek, {
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    final currentDay = state.availability[dayOfWeek]!;
    final updatedAvailability = Map<int, DayAvailability>.from(
      state.availability,
    );
    updatedAvailability[dayOfWeek] = currentDay.copyWith(
      startTime: startTime,
      endTime: endTime,
    );
    emit(state.copyWith(availability: updatedAvailability));
  }
}
