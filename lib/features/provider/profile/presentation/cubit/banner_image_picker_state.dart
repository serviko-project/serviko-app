import 'dart:io';
import 'package:equatable/equatable.dart';

class BannerImagePickerState extends Equatable {
  final File? selectedImage;
  final bool isDeleted;

  const BannerImagePickerState({this.selectedImage, this.isDeleted = false});

  BannerImagePickerState copyWith({
    File? selectedImage,
    bool? isDeleted,
    bool clearImage = false,
  }) {
    return BannerImagePickerState(
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [selectedImage?.path, isDeleted];
}
