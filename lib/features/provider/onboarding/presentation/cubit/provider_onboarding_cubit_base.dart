import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/delete_document_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_categories_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_my_provider_profile_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/reapply_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_application_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/upload_document_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_my_profile_usecase.dart';

// Base class for ProviderOnboardingCubit
abstract class ProviderOnboardingCubitBase
    extends Cubit<ProviderOnboardingState> {
  ProviderOnboardingCubitBase(super.initialState);

  // Use Cases
  SubmitApplicationUseCase get submitApplicationUseCase;
  GetMyProviderProfileUseCase get getMyProviderProfileUseCase;
  UploadDocumentUseCase get uploadDocumentUseCase;
  DeleteDocumentUseCase get deleteDocumentUseCase;
  ReapplyUseCase get reapplyUseCase;
  GetCategoriesUseCase get getCategoriesUseCase;
  GetMyProfileUseCase get getMyProfileUseCase;

  // Controllers
  PageController get pageController;
  GlobalKey<FormState> get formKey;
  TextEditingController get titleController;
  TextEditingController get aboutController;

  // Location Service
  LocationService get locationService;

  // Helpers
  TimeOfDay parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
