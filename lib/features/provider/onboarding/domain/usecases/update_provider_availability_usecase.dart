import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

class UpdateProviderAvailabilityUseCase
    implements
        UseCase<ProviderProfileEntity, UpdateProviderAvailabilityParams> {
  final ProviderOnboardingRepository repository;

  UpdateProviderAvailabilityUseCase(this.repository);

  @override
  Future<Either<Failure, ProviderProfileEntity>> call(
    UpdateProviderAvailabilityParams params,
  ) async {
    return await repository.updateProviderAvailability(params.availability);
  }
}

class UpdateProviderAvailabilityParams extends Equatable {
  final List<Map<String, dynamic>> availability;

  const UpdateProviderAvailabilityParams({required this.availability});

  @override
  List<Object?> get props => [availability];
}
