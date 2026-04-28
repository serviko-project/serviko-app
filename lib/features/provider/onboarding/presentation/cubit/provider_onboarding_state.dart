import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ProviderOnboardingStatus { initial, submitting, success, error }

// Provider Onboarding State
class ProviderOnboardingState extends Equatable {
  final int currentStep;
  final ProviderOnboardingStatus status;
  final String? errorMessage;

  // Step 2: Details
  final int yearsOfExperience;

  // Step 3: Services
  final Set<String> selectedServices;

  // Step 4: Availability
  final Map<int, DayAvailability> availability;

  // Step 5: Documents
  final String? document1Path;
  final String? document2Path;

  // Step 6: Service Area
  final double coverageRadius;

  const ProviderOnboardingState({
    this.currentStep = 0,
    this.status = ProviderOnboardingStatus.initial,
    this.errorMessage,
    this.yearsOfExperience = 0,
    this.selectedServices = const {},
    this.availability = const {},
    this.document1Path,
    this.document2Path,
    this.coverageRadius = 15.0,
  });

  ProviderOnboardingState copyWith({
    int? currentStep,
    ProviderOnboardingStatus? status,
    String? errorMessage,
    int? yearsOfExperience,
    Set<String>? selectedServices,
    Map<int, DayAvailability>? availability,
    String? document1Path,
    String? document2Path,
    double? coverageRadius,
    bool clearDocument1 = false,
    bool clearDocument2 = false,
  }) {
    return ProviderOnboardingState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      errorMessage: errorMessage,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      selectedServices: selectedServices ?? this.selectedServices,
      availability: availability ?? this.availability,
      document1Path: clearDocument1
          ? null
          : (document1Path ?? this.document1Path),
      document2Path: clearDocument2
          ? null
          : (document2Path ?? this.document2Path),
      coverageRadius: coverageRadius ?? this.coverageRadius,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    status,
    errorMessage,
    yearsOfExperience,
    selectedServices,
    availability,
    document1Path,
    document2Path,
    coverageRadius,
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

  @override
  List<Object?> get props => [isEnabled, startTime, endTime];
}
