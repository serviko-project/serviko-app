import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/banner_image_picker_state.dart';

class BannerImagePickerCubit extends Cubit<BannerImagePickerState> {
  BannerImagePickerCubit() : super(const BannerImagePickerState());

  void setImage(File image) {
    emit(state.copyWith(selectedImage: image, isDeleted: false));
  }

  void removeImage() {
    emit(state.copyWith(clearImage: true, isDeleted: true));
  }
}
