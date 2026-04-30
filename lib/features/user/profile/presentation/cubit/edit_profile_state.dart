import 'dart:io';
import 'package:equatable/equatable.dart';

enum EditProfileStatus { initial, submitting, success, error }

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final String? errorMessage;
  final String? gender;
  final File? selectedImage;
  final bool hasImage;
  final String? uploadedImageUrl;
  final bool isDeleted;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.errorMessage,
    this.gender,
    this.selectedImage,
    this.hasImage = false,
    this.uploadedImageUrl,
    this.isDeleted = false,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    String? errorMessage,
    String? gender,
    File? selectedImage,
    bool? hasImage,
    String? uploadedImageUrl,
    bool clearSelectedImage = false,
    bool clearUploadedUrl = false,
    bool? isDeleted,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      gender: gender ?? this.gender,
      selectedImage: clearSelectedImage
          ? null
          : (selectedImage ?? this.selectedImage),
      hasImage: hasImage ?? this.hasImage,
      uploadedImageUrl: clearUploadedUrl
          ? null
          : (uploadedImageUrl ?? this.uploadedImageUrl),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    gender,
    selectedImage,
    hasImage,
    uploadedImageUrl,
    isDeleted,
  ];
}
