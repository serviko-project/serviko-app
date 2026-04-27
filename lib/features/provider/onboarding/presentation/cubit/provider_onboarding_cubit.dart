import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

class ProviderOnboardingCubit extends Cubit<ProviderOnboardingState> {
  final PageController pageController;

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final titleFocusNode = FocusNode();
  final aboutController = TextEditingController();
  final aboutFocusNode = FocusNode();

  ProviderOnboardingCubit()
    : pageController = PageController(),
      super(const ProviderOnboardingState()) {
    _initAvailability();
  }

  // Initialize availability with default values (Monday to Friday enabled, 9am-5pm)
  void _initAvailability() {
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

  @override
  Future<void> close() {
    pageController.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    aboutController.dispose();
    aboutFocusNode.dispose();
    return super.close();
  }

  // ---- Navigation ----
  void nextStep() {
    // Step 1: Personal Details
    if (state.currentStep == 1 &&
        !(formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Step 2: Services
    if (state.currentStep == 2 && state.selectedServices.isEmpty) {
      return;
    }

    // Step 4: Documents
    if (state.currentStep == 4) {
      if (state.document1Path == null || state.document2Path == null) {
        return;
      }
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

  // ---- Step 2: Details ----
  void setYearsOfExperience(int years) {
    if (years >= 0 && years <= 50) {
      emit(state.copyWith(yearsOfExperience: years));
    }
  }

  // ---- Step 3: Services ----
  void toggleService(String serviceId) {
    final updatedServices = Set<String>.from(state.selectedServices);
    if (updatedServices.contains(serviceId)) {
      updatedServices.remove(serviceId);
    } else {
      updatedServices.add(serviceId);
    }
    emit(state.copyWith(selectedServices: updatedServices));
  }

  // ---- Step 4: Availability ----
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

  // ---- Step 5: Documents ----
  Future<void> pickDocument(int docNumber) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final path = '/path/document_$docNumber.pdf';

    if (docNumber == 1) {
      emit(state.copyWith(document1Path: path));
    } else if (docNumber == 2) {
      emit(state.copyWith(document2Path: path));
    }
  }

  void removeDocument(int docNumber) {
    if (docNumber == 1) {
      emit(state.copyWith(clearDocument1: true));
    } else if (docNumber == 2) {
      emit(state.copyWith(clearDocument2: true));
    }
  }

  // ---- Step 6: Service Area ----
  void setCoverageRadius(double radius) {
    emit(state.copyWith(coverageRadius: radius));
  }

  // ---- Final Submission ----
  void submitOnboarding() async {
    emit(state.copyWith(status: ProviderOnboardingStatus.submitting));

    await Future.delayed(const Duration(seconds: 2));

    // Success
    emit(state.copyWith(status: ProviderOnboardingStatus.success));
  }
}
