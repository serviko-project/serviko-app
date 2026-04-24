part of 'fill_profile_cubit.dart';

// Fill profile submission status
enum FillProfileStatus { idle, submitting, success, error }

// Fill profile form state
class FillProfileState {
  final String? gender;
  final FillProfileStatus status;
  final String? errorMessage;
  final UserProfileEntity? profile;

  const FillProfileState({
    this.gender,
    this.status = FillProfileStatus.idle,
    this.errorMessage,
    this.profile,
  });

  FillProfileState copyWith({
    String? gender,
    FillProfileStatus? status,
    String? errorMessage,
    UserProfileEntity? profile,
  }) => FillProfileState(
    gender: gender ?? this.gender,
    status: status ?? this.status,
    errorMessage: errorMessage,
    profile: profile ?? this.profile,
  );
}
