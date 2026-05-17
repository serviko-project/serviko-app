import 'package:flutter/material.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/delete_document_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_categories_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_my_provider_profile_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/reapply_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_application_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/upload_document_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/onboarding_data_mixin.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/onboarding_document_mixin.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/onboarding_form_mixin.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/onboarding_location_mixin.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/onboarding_navigation_mixin.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/onboarding_submission_mixin.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit_base.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_category_request_usecase.dart';

class ProviderOnboardingCubit extends ProviderOnboardingCubitBase
    with
        OnboardingDataMixin,
        OnboardingFormMixin,
        OnboardingNavigationMixin,
        OnboardingLocationMixin,
        OnboardingDocumentMixin,
        OnboardingSubmissionMixin {
  final SubmitApplicationUseCase _submitApplicationUseCase;
  final GetMyProviderProfileUseCase _getMyProviderProfileUseCase;
  final UploadDocumentUseCase _uploadDocumentUseCase;
  final DeleteDocumentUseCase _deleteDocumentUseCase;
  final ReapplyUseCase _reapplyUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetMyProfileUseCase _getMyProfileUseCase;
  final SubmitCategoryRequestUseCase _submitCategoryRequestUseCase;
  final LocationService _locationService;
  final bool isReapplication;

  @override
  final PageController pageController;

  @override
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
    required SubmitCategoryRequestUseCase submitCategoryRequestUseCase,
    LocationService? locationService,
    this.isReapplication = false,
  }) : _submitApplicationUseCase = submitApplicationUseCase,
       _getMyProviderProfileUseCase = getMyProviderProfileUseCase,
       _uploadDocumentUseCase = uploadDocumentUseCase,
       _deleteDocumentUseCase = deleteDocumentUseCase,
       _reapplyUseCase = reapplyUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       _getMyProfileUseCase = getMyProfileUseCase,
       _submitCategoryRequestUseCase = submitCategoryRequestUseCase,
       _locationService = locationService ?? LocationService(),
       pageController = PageController(),
       super(ProviderOnboardingState(isReapplication: isReapplication)) {
    initAvailability();
    loadCategories();
    loadUserProfile();
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
  SubmitCategoryRequestUseCase get submitCategoryRequestUseCase =>
      _submitCategoryRequestUseCase;
  @override
  LocationService get locationService => _locationService;

  @override
  Future<void> close() {
    pageController.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    aboutController.dispose();
    aboutFocusNode.dispose();
    return super.close();
  }

  void clearError() => emit(state.copyWith(clearError: true));
}
