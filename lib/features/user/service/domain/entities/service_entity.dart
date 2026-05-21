import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String providerId;
  final String providerName;
  final String? providerImage;
  final String? providerFirebaseUid;
  final String? bannerImage;
  final String professionalTitle;
  final double basePricePerHour;
  final double rating;
  final int reviewsCount;
  final int? yearsOfExperience;
  final String? about;
  final List<String> galleryImages;
  final List<ProviderServiceEntity> allCategories;
  final double? latitude;
  final double? longitude;

  const ServiceEntity({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.providerId,
    required this.providerName,
    this.providerImage,
    this.providerFirebaseUid,
    this.bannerImage,
    required this.professionalTitle,
    required this.basePricePerHour,
    required this.rating,
    required this.reviewsCount,
    this.yearsOfExperience,
    this.about,
    this.galleryImages = const [],
    this.allCategories = const [],
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    categoryName,
    categoryIcon,
    providerId,
    providerName,
    providerImage,
    providerFirebaseUid,
    bannerImage,
    professionalTitle,
    basePricePerHour,
    rating,
    reviewsCount,
    yearsOfExperience,
    about,
    galleryImages,
    allCategories,
    latitude,
    longitude,
  ];
}

class ProviderServiceEntity extends Equatable {
  final String categoryId;
  final String categoryName;
  final double basePricePerHour;

  const ProviderServiceEntity({
    required this.categoryId,
    required this.categoryName,
    required this.basePricePerHour,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, basePricePerHour];
}
