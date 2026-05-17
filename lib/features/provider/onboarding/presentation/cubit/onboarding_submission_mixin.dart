import 'package:flutter/material.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_application_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_category_request_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit_base.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

// Submission, re-application and pre-fill logic
mixin OnboardingSubmissionMixin on ProviderOnboardingCubitBase {
  // Submit or re-apply the provider application
  Future<void> submitOnboarding() async {
    emit(state.copyWith(status: ProviderOnboardingStatus.submitting));

    final availabilitySlots = state.availability.entries.map((entry) {
      final day = entry.value;
      return AvailabilitySlotParams(
        dayOfWeek: entry.key,
        isEnabled: day.isEnabled,
        startTime: DayAvailability.formatTime(day.startTime),
        endTime: DayAvailability.formatTime(day.endTime),
      );
    }).toList();

    final serviceCategories = state.selectedServices.map((id) {
      return ServiceCategoryParam(
        categoryId: id,
        basePricePerHour: state.categoryPrices[id] ?? 0,
      );
    }).toList();

    final params = SubmitApplicationParams(
      professionalTitle: titleController.text.trim(),
      yearsOfExperience: state.yearsOfExperience,
      about: aboutController.text.trim().isNotEmpty
          ? aboutController.text.trim()
          : null,
      serviceCategories: serviceCategories,
      availability: availabilitySlots,
      latitude: state.latitude,
      longitude: state.longitude,
      coverageRadiusKm: state.coverageRadius,
    );

    final result = state.isReapplication
        ? await reapplyUseCase(params)
        : await submitApplicationUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderOnboardingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (profile) =>
          emit(state.copyWith(status: ProviderOnboardingStatus.success)),
    );
  }

  // Pre-fill form data from existing provider profile
  Future<void> prefillFromExistingProfile() async {
    emit(state.copyWith(status: ProviderOnboardingStatus.loading));
    final result = await getMyProviderProfileUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderOnboardingStatus.initial,
          errorMessage: failure.message,
        ),
      ),
      (profile) {
        titleController.text = profile.professionalTitle ?? '';
        aboutController.text = profile.about ?? '';

        final selectedIds = profile.services.map((s) => s.categoryId).toSet();

        // Pre-fill per-category prices
        final Map<String, double> prices = {};
        for (final service in profile.services) {
          if (service.basePricePerHour != null) {
            prices[service.categoryId] = service.basePricePerHour!;
          }
        }

        final Map<int, DayAvailability> prefillAvailability = {};
        for (final slot in profile.availability) {
          prefillAvailability[slot.dayOfWeek] = DayAvailability(
            isEnabled: slot.isEnabled,
            startTime: parseTime(slot.startTime),
            endTime: parseTime(slot.endTime),
          );
        }
        for (int i = 1; i <= 7; i++) {
          prefillAvailability.putIfAbsent(
            i,
            () => DayAvailability(
              isEnabled: i <= 5,
              startTime: const TimeOfDay(hour: 9, minute: 0),
              endTime: const TimeOfDay(hour: 17, minute: 0),
            ),
          );
        }

        // Pre-fill documents
        final govDoc = profile.documents
            .where((d) => d.documentType == 'government_id')
            .firstOrNull;
        final certDoc = profile.documents
            .where((d) => d.documentType == 'professional_certificate')
            .firstOrNull;

        emit(
          state.copyWith(
            status: ProviderOnboardingStatus.initial,
            yearsOfExperience: profile.yearsOfExperience ?? 0,
            selectedServices: selectedIds,
            categoryPrices: prices,
            availability: prefillAvailability,
            governmentIdDoc: govDoc,
            certificateDoc: certDoc,
            coverageRadius: profile.coverageRadiusKm ?? 15.0,
            latitude: profile.latitude,
            longitude: profile.longitude,
          ),
        );
      },
    );
  }

  // Check if user already has a submitted application
  Future<void> checkExistingApplication() async {
    final result = await getMyProviderProfileUseCase(const NoParams());
    result.fold((_) {}, (profile) {
      final status = profile.status.toLowerCase();
      if (status == 'pending' || status == 'approved') {
        emit(state.copyWith(status: ProviderOnboardingStatus.alreadySubmitted));
      }
    });
  }

  // Submit a category request
  Future<void> submitCategoryRequest({
    required String title,
    required String description,
    required double proposedBasePrice,
  }) async {
    emit(
      state.copyWith(
        isSubmittingCategoryRequest: true,
        categoryRequestSuccess: false,
        clearError: true,
      ),
    );

    final params = SubmitCategoryRequestParams(
      title: title,
      description: description,
      proposedBasePrice: proposedBasePrice,
    );

    final result = await submitCategoryRequestUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSubmittingCategoryRequest: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isSubmittingCategoryRequest: false,
          categoryRequestSuccess: true,
        ),
      ),
    );
  }

  void resetCategoryRequestSuccess() {
    emit(state.copyWith(categoryRequestSuccess: false));
  }
}
