import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serviko_app/features/user/profile/domain/entities/profile_entity.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/create_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/update_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/upload_profile_image_usecase.dart';
part 'fill_profile_state.dart';

// Cubit for managing fill profile form state and submission
class FillProfileCubit extends Cubit<FillProfileState> {
  final CreateUserProfileUseCase _createUserProfileUseCase;
  final UpdateProfileUseCase _updateUserProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final DeleteProfileImageUseCase _deleteProfileImageUseCase;
  final ImagePicker _imagePicker;

  FillProfileCubit({
    required CreateUserProfileUseCase createUserProfileUseCase,
    required UpdateProfileUseCase updateUserProfileUseCase,
    required UploadProfileImageUseCase uploadProfileImageUseCase,
    required DeleteProfileImageUseCase deleteProfileImageUseCase,
    ImagePicker? imagePicker,
  }) : _createUserProfileUseCase = createUserProfileUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _uploadProfileImageUseCase = uploadProfileImageUseCase,
       _deleteProfileImageUseCase = deleteProfileImageUseCase,
       _imagePicker = imagePicker ?? ImagePicker(),
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

  // Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked == null) return;

      final file = File(picked.path);
      emit(
        state.copyWith(
          selectedImage: file,
          imageStatus: ImageUploadStatus.idle,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          imageStatus: ImageUploadStatus.error,
          imageError: 'Failed to pick image. Please try again.',
        ),
      );
    }
  }

  // Remove locally selected image
  void clearSelectedImage() {
    emit(state.copyWith(clearImage: true, imageStatus: ImageUploadStatus.idle));
  }

  // Remove uploaded image
  Future<void> deleteUploadedImage() async {
    final result = await _deleteProfileImageUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          imageStatus: ImageUploadStatus.error,
          imageError: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          imageStatus: ImageUploadStatus.idle,
          clearImage: true,
          clearUploadedUrl: true,
          profile: profile,
        ),
      ),
    );
  }

  // Submit profile data and handle image upload
  Future<void> submitProfile() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(status: FillProfileStatus.submitting));

    final requestResult = state.profile != null
        ? await _updateUserProfileUseCase(
            UpdateProfileParams(
              fullName: fullNameController.text.trim(),
              phoneNumber: phoneController.text.trim().isEmpty
                  ? null
                  : phoneController.text.trim(),
              dateOfBirth: _selectedDob,
              gender: state.gender,
            ),
          )
        : await _createUserProfileUseCase(
            CreateProfileParams(
              fullName: fullNameController.text.trim(),
              phoneNumber: phoneController.text.trim().isEmpty
                  ? null
                  : phoneController.text.trim(),
              dateOfBirth: _selectedDob,
              gender: state.gender,
            ),
          );

    await requestResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: FillProfileStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (profile) async {
        // If profile updated/created successfully, upload image if selected
        if (state.selectedImage != null) {
          final uploadResult = await _uploadProfileImageUseCase(
            state.selectedImage!,
          );

          uploadResult.fold(
            (failure) {
              // Image upload failed but profile was created/updated
              emit(
                state.copyWith(
                  status: FillProfileStatus.success,
                  imageStatus: ImageUploadStatus.error,
                  imageError: 'Profile saved, but image upload failed.',
                  profile: profile,
                ),
              );
            },
            (updatedProfile) {
              emit(
                state.copyWith(
                  status: FillProfileStatus.success,
                  imageStatus: ImageUploadStatus.uploaded,
                  uploadedImageUrl: updatedProfile.profileImageUrl,
                  profile: updatedProfile,
                ),
              );
            },
          );
        } else {
          // No image to upload
          emit(
            state.copyWith(status: FillProfileStatus.success, profile: profile),
          );
        }
      },
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
