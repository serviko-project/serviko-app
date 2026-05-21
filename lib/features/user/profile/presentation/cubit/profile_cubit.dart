import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_cached_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/update_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_state.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/update_firebase_display_name_usecase.dart';

// Profile Cubit
class ProfileCubit extends Cubit<ProfileState> {
  final GetMyProfileUseCase _getMyProfileUseCase;
  final GetCachedProfileUseCase _getCachedProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final DeleteProfileImageUseCase _deleteProfileImageUseCase;
  final UpdateFirebaseDisplayNameUseCase _updateFirebaseDisplayNameUseCase;

  ProfileCubit({
    required GetMyProfileUseCase getMyProfileUseCase,
    required GetCachedProfileUseCase getCachedProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UploadProfileImageUseCase uploadProfileImageUseCase,
    required DeleteProfileImageUseCase deleteProfileImageUseCase,
    required UpdateFirebaseDisplayNameUseCase updateFirebaseDisplayNameUseCase,
  }) : _getMyProfileUseCase = getMyProfileUseCase,
       _getCachedProfileUseCase = getCachedProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       _uploadProfileImageUseCase = uploadProfileImageUseCase,
       _deleteProfileImageUseCase = deleteProfileImageUseCase,
       _updateFirebaseDisplayNameUseCase = updateFirebaseDisplayNameUseCase,
       super(const ProfileInitial());

  Future<void> loadCachedProfile() async {
    final result = await _getCachedProfileUseCase(const NoParams());
    result.fold((_) => null, (profile) {
      if (profile != null) {
        emit(ProfileLoaded(profile));
      }
    });
  }

  Future<void> fetchProfile() async {
    if (state is ProfileLoading) return;

    final currentProfile = state is ProfileLoaded
        ? (state as ProfileLoaded).profile
        : null;

    if (state is ProfileInitial) {
      await loadCachedProfile();
    }

    if (state is! ProfileLoaded) {
      emit(const ProfileLoading());
    }

    final result = await _getMyProfileUseCase(const NoParams());

    result.fold((failure) {
      final hasData = currentProfile != null || state is ProfileLoaded;

      if (!hasData) {
        emit(ProfileError(failure.message));
      }
    }, (profile) => emit(ProfileLoaded(profile)));
  }

  Future<void> updateProfile({
    required String fullName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
  }) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(const ProfileLoading());

    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        fullName: fullName,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        gender: gender,
      ),
    );

    await result.fold((failure) async => emit(ProfileError(failure.message)), (
      profile,
    ) async {
      await _updateFirebaseDisplayNameUseCase(fullName);
      emit(ProfileLoaded(profile));
    });
  }

  Future<void> uploadProfileImage(File imageFile) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(const ProfileLoading());

    final result = await _uploadProfileImageUseCase(imageFile);

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> deleteProfileImage() async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(const ProfileLoading());

    final result = await _deleteProfileImageUseCase();

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  void reset() {
    emit(const ProfileInitial());
  }
}
