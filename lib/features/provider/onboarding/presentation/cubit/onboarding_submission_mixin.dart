import 'package:flutter/material.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_application_usecase.dart';
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

    final params = SubmitApplicationParams(
      professionalTitle: titleController.text.trim(),
      yearsOfExperience: state.yearsOfExperience,
      about: aboutController.text.trim().isNotEmpty
          ? aboutController.text.trim()
          : null,
      serviceCategoryIds: state.selectedServices.toList(),
      availability: availabilitySlots,
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
            availability: prefillAvailability,
            governmentIdDoc: govDoc,
            certificateDoc: certDoc,
            coverageRadius: profile.coverageRadiusKm ?? 15.0,
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
}
