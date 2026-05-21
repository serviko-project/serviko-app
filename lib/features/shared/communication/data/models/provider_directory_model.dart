import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';

class ProviderDirectoryModel extends ProviderDirectoryEntity {
  const ProviderDirectoryModel({
    required super.id,
    required super.userId,
    required super.firebaseUid,
    super.name,
    super.profileImageUrl,
    super.professionalTitle,
    super.about,
    super.bannerImageUrl,
    super.categories,
  });

  factory ProviderDirectoryModel.fromJson(Map<String, dynamic> json) {
    return ProviderDirectoryModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      firebaseUid: json['firebase_uid'] as String? ?? '',
      name: json['user_name'] as String?,
      profileImageUrl: json['user_profile_image_url'] as String?,
      professionalTitle: json['professional_title'] as String?,
      about: json['about'] as String?,
      bannerImageUrl: json['banner_image_url'] as String?,
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
    );
  }
}
