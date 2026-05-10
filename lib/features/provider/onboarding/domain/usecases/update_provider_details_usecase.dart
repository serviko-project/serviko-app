import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

class UpdateProviderDetailsUseCase
    implements UseCase<ProviderProfileEntity, UpdateProviderDetailsParams> {
  final ProviderOnboardingRepository repository;

  UpdateProviderDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ProviderProfileEntity>> call(
    UpdateProviderDetailsParams params,
  ) async {
    return await repository.updateProviderDetails(params.toJson());
  }
}

class UpdateProviderDetailsParams extends Equatable {
  final String? professionalTitle;
  final String? bio;
  final int? yearsOfExperience;

  const UpdateProviderDetailsParams({
    this.professionalTitle,
    this.bio,
    this.yearsOfExperience,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (professionalTitle != null) {
      data['professional_title'] = professionalTitle;
    }
    if (bio != null) {
      data['about'] = bio;
    }
    if (yearsOfExperience != null) {
      data['years_of_experience'] = yearsOfExperience;
    }
    return data;
  }

  @override
  List<Object?> get props => [professionalTitle, bio, yearsOfExperience];
}
