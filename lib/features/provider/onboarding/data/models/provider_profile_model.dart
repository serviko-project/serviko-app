import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';

// Provider profile model
class ProviderProfileModel extends ProviderProfileEntity {
  const ProviderProfileModel({
    required super.id,
    required super.userId,
    super.userName,
    super.userProfileImageUrl,
    super.professionalTitle,
    super.yearsOfExperience,
    super.about,
    required super.status,
    super.rejectionReason,
    super.submittedAt,
    super.reviewedAt,
    super.latitude,
    super.longitude,
    super.coverageRadiusKm,
    super.bannerImageUrl,
    super.services,
    super.availability,
    super.documents,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    return ProviderProfileModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      userProfileImageUrl: json['user_profile_image_url'] as String?,
      professionalTitle: json['professional_title'] as String?,
      yearsOfExperience: json['years_of_experience'] as int?,
      about: json['about'] as String?,
      status: json['status'] as String,
      rejectionReason: json['rejection_reason'] as String?,
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      coverageRadiusKm: (json['coverage_radius_km'] as num?)?.toDouble(),
      bannerImageUrl: json['banner_image_url'] as String?,
      services:
          (json['services'] as List<dynamic>?)
              ?.map(
                (s) => ProviderServiceModel.fromJson(s as Map<String, dynamic>),
              )
              .toList() ??
          [],
      availability:
          (json['availability'] as List<dynamic>?)
              ?.map(
                (a) => ProviderAvailabilityModel.fromJson(
                  a as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      documents:
          (json['documents'] as List<dynamic>?)
              ?.map(
                (d) =>
                    ProviderDocumentModel.fromJson(d as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

// Provider service model
class ProviderServiceModel extends ProviderServiceEntity {
  const ProviderServiceModel({
    required super.id,
    required super.categoryId,
    required super.categoryTitle,
    required super.categoryIcon,
    required super.basePricePerHour,
  });

  factory ProviderServiceModel.fromJson(Map<String, dynamic> json) {
    return ProviderServiceModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      categoryTitle: json['category_title'] as String,
      categoryIcon: json['category_icon'] as String,
      basePricePerHour: (json['base_price_per_hour'] as num?)?.toDouble(),
    );
  }
}

// Provider availability model
class ProviderAvailabilityModel extends ProviderAvailabilityEntity {
  const ProviderAvailabilityModel({
    required super.id,
    required super.dayOfWeek,
    required super.isEnabled,
    required super.startTime,
    required super.endTime,
  });

  factory ProviderAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return ProviderAvailabilityModel(
      id: json['id'] as String,
      dayOfWeek: json['day_of_week'] as int,
      isEnabled: json['is_enabled'] as bool,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }
}

// Provider document model
class ProviderDocumentModel extends ProviderDocumentEntity {
  const ProviderDocumentModel({
    required super.id,
    required super.documentType,
    required super.fileUrl,
    required super.originalFilename,
  });

  factory ProviderDocumentModel.fromJson(Map<String, dynamic> json) {
    return ProviderDocumentModel(
      id: json['id'] as String,
      documentType: json['document_type'] as String,
      fileUrl: json['file_url'] as String,
      originalFilename: json['original_filename'] as String?,
    );
  }
}
