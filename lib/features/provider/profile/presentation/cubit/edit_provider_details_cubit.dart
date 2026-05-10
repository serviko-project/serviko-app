import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/delete_banner_image_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/update_provider_details_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/upload_banner_image_usecase.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_details_state.dart';

class EditProviderDetailsCubit extends Cubit<EditProviderDetailsState> {
  final UpdateProviderDetailsUseCase _updateProviderDetailsUseCase;
  final UploadBannerImageUseCase _uploadBannerImageUseCase;
  final DeleteBannerImageUseCase _deleteBannerImageUseCase;

  EditProviderDetailsCubit({
    required UpdateProviderDetailsUseCase updateProviderDetailsUseCase,
    required UploadBannerImageUseCase uploadBannerImageUseCase,
    required DeleteBannerImageUseCase deleteBannerImageUseCase,
  }) : _updateProviderDetailsUseCase = updateProviderDetailsUseCase,
       _uploadBannerImageUseCase = uploadBannerImageUseCase,
       _deleteBannerImageUseCase = deleteBannerImageUseCase,
       super(EditProviderDetailsInitial());

  Future<void> updateDetails({
    required String professionalTitle,
    required String bio,
    required int yearsOfExperience,
  }) async {
    emit(EditProviderDetailsLoading());
    final result = await _updateProviderDetailsUseCase(
      UpdateProviderDetailsParams(
        professionalTitle: professionalTitle,
        bio: bio,
        yearsOfExperience: yearsOfExperience,
      ),
    );

    result.fold(
      (failure) => emit(EditProviderDetailsError(failure.message)),
      (_) => emit(
        const EditProviderDetailsSuccess('Details updated successfully'),
      ),
    );
  }

  Future<void> uploadBannerImage(File file) async {
    emit(BannerImageUploadLoading());
    final result = await _uploadBannerImageUseCase(file);

    result.fold(
      (failure) => emit(BannerImageUploadError(failure.message)),
      (_) => emit(
        const BannerImageUploadSuccess('Banner image uploaded successfully'),
      ),
    );
  }

  Future<void> deleteBannerImage() async {
    emit(BannerImageDeleteLoading());
    final result = await _deleteBannerImageUseCase(NoParams());

    result.fold(
      (failure) => emit(BannerImageDeleteError(failure.message)),
      (_) => emit(
        const BannerImageDeleteSuccess('Banner image deleted successfully'),
      ),
    );
  }
}
