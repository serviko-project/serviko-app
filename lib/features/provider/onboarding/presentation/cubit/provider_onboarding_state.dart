import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/category_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';

enum ProviderOnboardingStatus {
  initial,
  loading,
  submitting,
  success,
  alreadySubmitted,
  error,
}

// Provider Onboarding State
class ProviderOnboardingState extends Equatable {
  final int currentStep;
  final ProviderOnboardingStatus status;
  final String? errorMessage;

  // Step 2: Details
  final int yearsOfExperience;

  // Step 3: Services
  final List<CategoryEntity> availableCategories;
  final Set<String> selectedServices;
  final Map<String, double> categoryPrices;
  final bool isCategoriesLoading;
  final bool showPriceValidation;

  // Custom Category Request
  final String? requestedCategoryTitle;
  final String? requestedCategoryDescription;
  final double? requestedCategoryPrice;
  final bool isSubmittingCategoryRequest;
  final bool categoryRequestSuccess;

  // Step 4: Availability
  final Map<int, DayAvailability> availability;

  // Step 5: Documents
  final ProviderDocumentEntity? governmentIdDoc;
  final ProviderDocumentEntity? certificateDoc;
  final bool isUploadingDoc1;
  final bool isUploadingDoc2;

  // Step 6: Service Area
  final double coverageRadius;
  final double? latitude;
  final double? longitude;
  final String? resolvedAddress;
  final bool isLocationLoading;

  // Re-application flag
  final bool isReapplication;

  // User profile info
  final String? userName;
  final String? profileImageUrl;

  const ProviderOnboardingState({
    this.currentStep = 0,
    this.status = ProviderOnboardingStatus.initial,
    this.errorMessage,
    this.yearsOfExperience = 0,
    this.availableCategories = const [],
    this.selectedServices = const {},
    this.categoryPrices = const {},
    this.isCategoriesLoading = false,
    this.showPriceValidation = false,
    this.requestedCategoryTitle,
    this.requestedCategoryDescription,
    this.requestedCategoryPrice,
    this.isSubmittingCategoryRequest = false,
    this.categoryRequestSuccess = false,
    this.availability = const {},
    this.governmentIdDoc,
    this.certificateDoc,
    this.isUploadingDoc1 = false,
    this.isUploadingDoc2 = false,
    this.coverageRadius = 15.0,
    this.latitude,
    this.longitude,
    this.resolvedAddress,
    this.isLocationLoading = false,
    this.isReapplication = false,
    this.userName,
    this.profileImageUrl,
  });

  ProviderOnboardingState copyWith({
    int? currentStep,
    ProviderOnboardingStatus? status,
    String? errorMessage,
    int? yearsOfExperience,
    List<CategoryEntity>? availableCategories,
    Set<String>? selectedServices,
    Map<String, double>? categoryPrices,
    bool? isCategoriesLoading,
    bool? showPriceValidation,
    String? requestedCategoryTitle,
    String? requestedCategoryDescription,
    double? requestedCategoryPrice,
    bool? isSubmittingCategoryRequest,
    bool? categoryRequestSuccess,
    Map<int, DayAvailability>? availability,
    ProviderDocumentEntity? governmentIdDoc,
    ProviderDocumentEntity? certificateDoc,
    bool? isUploadingDoc1,
    bool? isUploadingDoc2,
    double? coverageRadius,
    double? latitude,
    double? longitude,
    String? resolvedAddress,
    bool? isLocationLoading,
    bool? isReapplication,
    String? userName,
    String? profileImageUrl,
    bool clearGovernmentIdDoc = false,
    bool clearCertificateDoc = false,
    bool clearError = false,
  }) {
    return ProviderOnboardingState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      availableCategories: availableCategories ?? this.availableCategories,
      selectedServices: selectedServices ?? this.selectedServices,
      categoryPrices: categoryPrices ?? this.categoryPrices,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
      showPriceValidation: showPriceValidation ?? this.showPriceValidation,
      requestedCategoryTitle:
          requestedCategoryTitle ?? this.requestedCategoryTitle,
      requestedCategoryDescription:
          requestedCategoryDescription ?? this.requestedCategoryDescription,
      requestedCategoryPrice:
          requestedCategoryPrice ?? this.requestedCategoryPrice,
      isSubmittingCategoryRequest:
          isSubmittingCategoryRequest ?? this.isSubmittingCategoryRequest,
      categoryRequestSuccess:
          categoryRequestSuccess ?? this.categoryRequestSuccess,
      availability: availability ?? this.availability,
      governmentIdDoc: clearGovernmentIdDoc
          ? null
          : (governmentIdDoc ?? this.governmentIdDoc),
      certificateDoc: clearCertificateDoc
          ? null
          : (certificateDoc ?? this.certificateDoc),
      isUploadingDoc1: isUploadingDoc1 ?? this.isUploadingDoc1,
      isUploadingDoc2: isUploadingDoc2 ?? this.isUploadingDoc2,
      coverageRadius: coverageRadius ?? this.coverageRadius,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      resolvedAddress: resolvedAddress ?? this.resolvedAddress,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
      isReapplication: isReapplication ?? this.isReapplication,
      userName: userName ?? this.userName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    status,
    errorMessage,
    yearsOfExperience,
    availableCategories,
    selectedServices,
    categoryPrices,
    isCategoriesLoading,
    showPriceValidation,
    requestedCategoryTitle,
    requestedCategoryDescription,
    requestedCategoryPrice,
    isSubmittingCategoryRequest,
    categoryRequestSuccess,
    availability,
    governmentIdDoc,
    certificateDoc,
    isUploadingDoc1,
    isUploadingDoc2,
    coverageRadius,
    latitude,
    longitude,
    resolvedAddress,
    isLocationLoading,
    isReapplication,
    userName,
    profileImageUrl,
  ];
}

class DayAvailability extends Equatable {
  final bool isEnabled;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const DayAvailability({
    required this.isEnabled,
    required this.startTime,
    required this.endTime,
  });

  DayAvailability copyWith({
    bool? isEnabled,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return DayAvailability(
      isEnabled: isEnabled ?? this.isEnabled,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  // Convert TimeOfDay to "HH:mm"
  static String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [isEnabled, startTime, endTime];
}
