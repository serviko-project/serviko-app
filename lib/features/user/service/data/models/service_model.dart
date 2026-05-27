import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.categoryId,
    required super.categoryName,
    required super.categoryIcon,
    required super.providerId,
    required super.providerName,
    super.providerImage,
    super.providerFirebaseUid,
    super.bannerImage,
    required super.professionalTitle,
    required super.basePricePerHour,
    required super.rating,
    required super.reviewsCount,
    super.yearsOfExperience,
    super.about,
    super.galleryImages,
    super.allCategories,
    super.latitude,
    super.longitude,
    super.isBookmarked = false,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      categoryIcon: json['category_icon'] as String,
      providerId: json['provider_id'] as String,
      providerName: json['provider_name'] as String,
      providerImage: json['provider_image'] as String?,
      providerFirebaseUid: json['provider_firebase_uid'] as String?,
      bannerImage: json['banner_image'] as String?,
      professionalTitle: json['professional_title'] as String,
      basePricePerHour: (json['base_price_per_hour'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'] as int,
      yearsOfExperience: json['years_of_experience'] as int?,
      about: json['about'] as String?,
      galleryImages:
          (json['gallery_images'] as List<dynamic>?)?.cast<String>() ?? [],
      allCategories:
          (json['all_categories'] as List<dynamic>?)
              ?.map(
                (e) => ProviderServiceModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'category_name': categoryName,
      'category_icon': categoryIcon,
      'provider_id': providerId,
      'provider_name': providerName,
      'provider_image': providerImage,
      'provider_firebase_uid': providerFirebaseUid,
      'banner_image': bannerImage,
      'professional_title': professionalTitle,
      'base_price_per_hour': basePricePerHour,
      'rating': rating,
      'reviews_count': reviewsCount,
      'years_of_experience': yearsOfExperience,
      'about': about,
      'gallery_images': galleryImages,
      'all_categories': allCategories
          .map((e) => (e as ProviderServiceModel).toJson())
          .toList(),
      'latitude': latitude,
      'longitude': longitude,
      'is_bookmarked': isBookmarked,
    };
  }
}

class ProviderServiceModel extends ProviderServiceEntity {
  const ProviderServiceModel({
    required super.categoryId,
    required super.categoryName,
    required super.basePricePerHour,
  });

  factory ProviderServiceModel.fromJson(Map<String, dynamic> json) {
    return ProviderServiceModel(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      basePricePerHour: (json['base_price_per_hour'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'base_price_per_hour': basePricePerHour,
    };
  }
}
