import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

class UpdateProviderServicesUseCase
    implements UseCase<ProviderProfileEntity, UpdateProviderServicesParams> {
  final ProviderOnboardingRepository repository;

  UpdateProviderServicesUseCase(this.repository);

  @override
  Future<Either<Failure, ProviderProfileEntity>> call(
    UpdateProviderServicesParams params,
  ) async {
    return await repository.updateProviderServices(params.services);
  }
}

class UpdateProviderServicesParams extends Equatable {
  final List<Map<String, dynamic>> services;

  const UpdateProviderServicesParams({required this.services});

  @override
  List<Object?> get props => [services];
}
