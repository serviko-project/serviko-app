import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/profile/domain/usecases/create_profile_usecase.dart';

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

// Cubit for managing fill profile form state and submission
class FillProfileCubit extends Cubit<FillProfileState> {
  final CreateUserProfileUseCase _createUserProfileUseCase;

  FillProfileCubit({required CreateUserProfileUseCase createUserProfileUseCase})
    : _createUserProfileUseCase = createUserProfileUseCase,
      super(const FillProfileState());

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final fullNameFocusNode = FocusNode();
  final dobFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  // Parsed DOB
  DateTime? _selectedDob;

  static const List<String> genderOptions = ['Male', 'Female', 'Other'];

  void updateGender(String? value) => emit(state.copyWith(gender: value));

  void setDateOfBirth(DateTime date) {
    _selectedDob = date;
    dobController.text =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // Submit profile data to backend
  Future<void> submitProfile() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(status: FillProfileStatus.submitting));

    final result = await _createUserProfileUseCase(
      CreateProfileParams(
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        dateOfBirth: _selectedDob,
        gender: state.gender,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FillProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(status: FillProfileStatus.success, profile: profile),
      ),
    );
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    fullNameFocusNode.dispose();
    dobFocusNode.dispose();
    phoneFocusNode.dispose();
    return super.close();
  }
}
