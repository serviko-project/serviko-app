import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

enum EditProviderAvailabilityStatus {
  initial,
  loading,
  loaded,
  updating,
  success,
  error,
}

class EditProviderAvailabilityState extends Equatable {
  final EditProviderAvailabilityStatus status;
  final Map<int, DayAvailability> availability;
  final String? errorMessage;
  final String? successMessage;

  const EditProviderAvailabilityState({
    this.status = EditProviderAvailabilityStatus.initial,
    this.availability = const {},
    this.errorMessage,
    this.successMessage,
  });

  EditProviderAvailabilityState copyWith({
    EditProviderAvailabilityStatus? status,
    Map<int, DayAvailability>? availability,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return EditProviderAvailabilityState(
      status: status ?? this.status,
      availability: availability ?? this.availability,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    availability,
    errorMessage,
    successMessage,
  ];
}
