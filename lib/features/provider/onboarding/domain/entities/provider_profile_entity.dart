import 'package:equatable/equatable.dart';

// Provider profile entity
class ProviderProfileEntity extends Equatable {
  final String id;
  final String userId;
  final String? userName;
  final String? userProfileImageUrl;
  final String? professionalTitle;
  final int? yearsOfExperience;
  final String? about;
  final String status;
  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final double? latitude;
  final double? longitude;
  final double? coverageRadiusKm;
  final List<ProviderServiceEntity> services;
  final List<ProviderAvailabilityEntity> availability;
  final List<ProviderDocumentEntity> documents;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProviderProfileEntity({
    required this.id,
    required this.userId,
    this.userName,
    this.userProfileImageUrl,
    this.professionalTitle,
    this.yearsOfExperience,
    this.about,
    required this.status,
    this.rejectionReason,
    this.submittedAt,
    this.reviewedAt,
    this.latitude,
    this.longitude,
    this.coverageRadiusKm,
    this.services = const [],
    this.availability = const [],
    this.documents = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userProfileImageUrl,
    professionalTitle,
    yearsOfExperience,
    about,
    status,
    rejectionReason,
    submittedAt,
    reviewedAt,
    latitude,
    longitude,
    coverageRadiusKm,
    services,
    availability,
    documents,
    createdAt,
    updatedAt,
  ];
}

// Service linked to provider
class ProviderServiceEntity extends Equatable {
  final String id;
  final String categoryId;
  final String categoryTitle;
  final String categoryIcon;

  const ProviderServiceEntity({
    required this.id,
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryIcon,
  });

  @override
  List<Object?> get props => [id, categoryId, categoryTitle, categoryIcon];
}

// Availability slot for a day
class ProviderAvailabilityEntity extends Equatable {
  final String id;
  final int dayOfWeek;
  final bool isEnabled;
  final String startTime;
  final String endTime;

  const ProviderAvailabilityEntity({
    required this.id,
    required this.dayOfWeek,
    required this.isEnabled,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [id, dayOfWeek, isEnabled, startTime, endTime];
}

// Uploaded document
class ProviderDocumentEntity extends Equatable {
  final String id;
  final String documentType;
  final String fileUrl;
  final String? originalFilename;

  const ProviderDocumentEntity({
    required this.id,
    required this.documentType,
    required this.fileUrl,
    this.originalFilename,
  });

  @override
  List<Object?> get props => [id, documentType, fileUrl, originalFilename];
}
