import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

// Submits provider application
class SubmitApplicationUseCase
    extends UseCase<ProviderProfileEntity, SubmitApplicationParams> {
  final ProviderOnboardingRepository _repository;

  SubmitApplicationUseCase(this._repository);

  @override
  Future<Either<Failure, ProviderProfileEntity>> call(
    SubmitApplicationParams params,
  ) {
    return _repository.submitApplication(params);
  }
}

// Params matching ProviderApplyCreate schema
class SubmitApplicationParams extends Equatable {
  final String professionalTitle;
  final int yearsOfExperience;
  final String? about;
  final List<ServiceCategoryParam> serviceCategories;
  final List<AvailabilitySlotParams> availability;
  final double? latitude;
  final double? longitude;
  final double coverageRadiusKm;

  const SubmitApplicationParams({
    required this.professionalTitle,
    required this.yearsOfExperience,
    this.about,
    required this.serviceCategories,
    required this.availability,
    this.latitude,
    this.longitude,
    this.coverageRadiusKm = 15.0,
  });

  Map<String, dynamic> toJson() => {
    'professional_title': professionalTitle,
    'years_of_experience': yearsOfExperience,
    'about': about,
    'service_categories': serviceCategories.map((s) => s.toJson()).toList(),
    'availability': availability.map((a) => a.toJson()).toList(),
    'latitude': latitude,
    'longitude': longitude,
    'coverage_radius_km': coverageRadiusKm,
  };

  @override
  List<Object?> get props => [
    professionalTitle,
    yearsOfExperience,
    about,
    serviceCategories,
    availability,
    latitude,
    longitude,
    coverageRadiusKm,
  ];
}

// Category + price
class ServiceCategoryParam extends Equatable {
  final String categoryId;
  final double basePricePerHour;

  const ServiceCategoryParam({
    required this.categoryId,
    required this.basePricePerHour,
  });

  Map<String, dynamic> toJson() => {
    'category_id': categoryId,
    'base_price_per_hour': basePricePerHour,
  };

  @override
  List<Object?> get props => [categoryId, basePricePerHour];
}

// Single day availability slot
class AvailabilitySlotParams extends Equatable {
  final int dayOfWeek;
  final bool isEnabled;
  final String startTime;
  final String endTime;

  const AvailabilitySlotParams({
    required this.dayOfWeek,
    required this.isEnabled,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
    'day_of_week': dayOfWeek,
    'is_enabled': isEnabled,
    'start_time': startTime,
    'end_time': endTime,
  };

  @override
  List<Object?> get props => [dayOfWeek, isEnabled, startTime, endTime];
}
