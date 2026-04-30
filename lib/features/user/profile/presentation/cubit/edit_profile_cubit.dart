import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/edit_profile_state.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileCubit _profileCubit;
  final ImagePicker _imagePicker;

  EditProfileCubit({
    required ProfileCubit profileCubit,
    ImagePicker? imagePicker,
  }) : _profileCubit = profileCubit,
       _imagePicker = imagePicker ?? ImagePicker(),
       super(const EditProfileState()) {
    _initializeFields();
  }

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final fullNameFocusNode = FocusNode();
  final dobFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  DateTime? _selectedDob;

  void _initializeFields() {
    final profileState = _profileCubit.state;
    if (profileState is ProfileLoaded) {
      final profile = profileState.profile;
      fullNameController.text = profile.fullName;
      phoneController.text = profile.phoneNumber ?? '';

      if (profile.dateOfBirth != null) {
        _selectedDob = profile.dateOfBirth;
        dobController.text = _formatDate(profile.dateOfBirth!);
      }

      // Map Gender with first letter capitalized for UI
      String? uiGender;
      if (profile.gender != null) {
        uiGender =
            profile.gender![0].toUpperCase() + profile.gender!.substring(1);
      }

      emit(
        state.copyWith(
          gender: uiGender,
          uploadedImageUrl: profile.profileImageUrl,
          hasImage:
              profile.profileImageUrl != null &&
              profile.profileImageUrl!.isNotEmpty,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void updateGender(String? value) => emit(state.copyWith(gender: value));

  void setDateOfBirth(DateTime date) {
    _selectedDob = date;
    dobController.text = _formatDate(date);
  }

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
        state.copyWith(selectedImage: file, hasImage: true, isDeleted: false),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: EditProfileStatus.error,
          errorMessage: 'Failed to pick image.',
        ),
      );
    }
  }

  void removeImage() {
    if (state.selectedImage != null) {
      // Clear locally picked image
      emit(
        state.copyWith(
          clearSelectedImage: true,
          hasImage: state.uploadedImageUrl != null && !state.isDeleted,
        ),
      );
    } else if (state.uploadedImageUrl != null) {
      emit(state.copyWith(isDeleted: true, hasImage: false));
    }
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(status: EditProfileStatus.submitting));

    // Update Profile info
    await _profileCubit.updateProfile(
      fullName: fullNameController.text.trim(),
      phoneNumber: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      dateOfBirth: _selectedDob,
      gender: state.gender,
    );

    // Handle image changes
    if (state.selectedImage != null) {
      await _profileCubit.uploadProfileImage(state.selectedImage!);
    } else if (state.isDeleted) {
      await _profileCubit.deleteProfileImage();
    }

    // Check for errors in ProfileCubit
    final finalState = _profileCubit.state;
    if (finalState is ProfileError) {
      emit(
        state.copyWith(
          status: EditProfileStatus.error,
          errorMessage: finalState.message,
        ),
      );
    } else {
      emit(state.copyWith(status: EditProfileStatus.success));
    }
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
