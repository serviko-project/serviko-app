import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';

// Application status screen state
class ApplicationStatusState extends Equatable {
  final bool isLoading;
  final ProviderProfileEntity? providerProfile;
  final String? errorMessage;

  const ApplicationStatusState({
    this.isLoading = false,
    this.providerProfile,
    this.errorMessage,
  });

  ApplicationStatusState copyWith({
    bool? isLoading,
    ProviderProfileEntity? providerProfile,
    String? errorMessage,
  }) {
    return ApplicationStatusState(
      isLoading: isLoading ?? this.isLoading,
      providerProfile: providerProfile ?? this.providerProfile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, providerProfile, errorMessage];
}
