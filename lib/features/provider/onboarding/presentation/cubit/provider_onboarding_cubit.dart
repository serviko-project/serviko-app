import 'package:flutter/material.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/delete_document_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_categories_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_my_provider_profile_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/reapply_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_application_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/upload_document_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/onboarding_document_mixin.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/onboarding_submission_mixin.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit_base.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_my_profile_usecase.dart';

class ProviderOnboardingCubit extends ProviderOnboardingCubitBase
    with OnboardingDocumentMixin, OnboardingSubmissionMixin {
  final SubmitApplicationUseCase _submitApplicationUseCase;
  final GetMyProviderProfileUseCase _getMyProviderProfileUseCase;
  final UploadDocumentUseCase _uploadDocumentUseCase;
  final DeleteDocumentUseCase _deleteDocumentUseCase;
  final ReapplyUseCase _reapplyUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetMyProfileUseCase _getMyProfileUseCase;
  final bool isReapplication;

  final PageController pageController;

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  @override
  final titleController = TextEditingController();
  final titleFocusNode = FocusNode();
  @override
  final aboutController = TextEditingController();
  final aboutFocusNode = FocusNode();

  ProviderOnboardingCubit({
    required SubmitApplicationUseCase submitApplicationUseCase,
    required GetMyProviderProfileUseCase getMyProviderProfileUseCase,
    required UploadDocumentUseCase uploadDocumentUseCase,
    required DeleteDocumentUseCase deleteDocumentUseCase,
    required ReapplyUseCase reapplyUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetMyProfileUseCase getMyProfileUseCase,
    this.isReapplication = false,
  }) : _submitApplicationUseCase = submitApplicationUseCase,
       _getMyProviderProfileUseCase = getMyProviderProfileUseCase,
       _uploadDocumentUseCase = uploadDocumentUseCase,
       _deleteDocumentUseCase = deleteDocumentUseCase,
       _reapplyUseCase = reapplyUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       _getMyProfileUseCase = getMyProfileUseCase,
       pageController = PageController(),
       super(ProviderOnboardingState(isReapplication: isReapplication)) {
    _initAvailability();
    loadCategories();
    _loadUserProfile();
    if (isReapplication) {
      prefillFromExistingProfile();
    } else {
      checkExistingApplication();
    }
  }

  @override
  SubmitApplicationUseCase get submitApplicationUseCase =>
      _submitApplicationUseCase;
  @override
  GetMyProviderProfileUseCase get getMyProviderProfileUseCase =>
      _getMyProviderProfileUseCase;
  @override
  UploadDocumentUseCase get uploadDocumentUseCase => _uploadDocumentUseCase;
  @override
  DeleteDocumentUseCase get deleteDocumentUseCase => _deleteDocumentUseCase;
  @override
  ReapplyUseCase get reapplyUseCase => _reapplyUseCase;
  @override
  GetCategoriesUseCase get getCategoriesUseCase => _getCategoriesUseCase;
  @override
  GetMyProfileUseCase get getMyProfileUseCase => _getMyProfileUseCase;

  @override
  Future<void> close() {
    pageController.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    aboutController.dispose();
    aboutFocusNode.dispose();
    return super.close();
  }

  // Load categories from API
  Future<void> loadCategories() async {
    emit(state.copyWith(isCategoriesLoading: true));
    final result = await _getCategoriesUseCase(const NoParams());
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
  Future<void> _loadUserProfile() async {
    final result = await _getMyProfileUseCase(const NoParams());
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

  // ---- Navigation ----
  void nextStep() {
    if (state.currentStep == 1 &&
        !(formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (state.currentStep == 2 && state.selectedServices.isEmpty) return;
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

  // ---- Form Setters ----
  void setYearsOfExperience(int years) {
    if (years >= 0 && years <= 50) {
      emit(state.copyWith(yearsOfExperience: years));
    }
  }

  void toggleService(String serviceId) {
    final updatedServices = Set<String>.from(state.selectedServices);
    if (updatedServices.contains(serviceId)) {
      updatedServices.remove(serviceId);
    } else {
      updatedServices.add(serviceId);
    }
    emit(state.copyWith(selectedServices: updatedServices));
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

  void setCoverageRadius(double radius) =>
      emit(state.copyWith(coverageRadius: radius));

  void clearError() => emit(state.copyWith(clearError: true));
}
