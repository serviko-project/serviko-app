part of 'fill_profile_cubit.dart';

// Fill profile submission status
enum FillProfileStatus { idle, submitting, success, error }

// Image upload status
enum ImageUploadStatus { idle, uploading, uploaded, error }

// Fill profile form state
class FillProfileState {
  final String? gender;
  final FillProfileStatus status;
  final String? errorMessage;
  final UserProfileEntity? profile;
  final File? selectedImage;
  final ImageUploadStatus imageStatus;
  final String? imageError;
  final String? uploadedImageUrl;

  const FillProfileState({
    this.gender,
    this.status = FillProfileStatus.idle,
    this.errorMessage,
    this.profile,
    this.selectedImage,
    this.imageStatus = ImageUploadStatus.idle,
    this.imageError,
    this.uploadedImageUrl,
  });

  bool get hasImage => selectedImage != null || uploadedImageUrl != null;

  FillProfileState copyWith({
    String? gender,
    FillProfileStatus? status,
    String? errorMessage,
    UserProfileEntity? profile,
    File? selectedImage,
    bool clearImage = false,
    ImageUploadStatus? imageStatus,
    String? imageError,
    String? uploadedImageUrl,
    bool clearUploadedUrl = false,
  }) => FillProfileState(
    gender: gender ?? this.gender,
    status: status ?? this.status,
    errorMessage: errorMessage,
    profile: profile ?? this.profile,
    selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
    imageStatus: imageStatus ?? this.imageStatus,
    imageError: imageError,
    uploadedImageUrl: clearUploadedUrl
        ? null
        : (uploadedImageUrl ?? this.uploadedImageUrl),
  );
}
