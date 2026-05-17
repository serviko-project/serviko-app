import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

class UploadBannerImageUseCase implements UseCase<ProviderProfileEntity, File> {
  final ProviderOnboardingRepository repository;

  UploadBannerImageUseCase(this.repository);

  @override
  Future<Either<Failure, ProviderProfileEntity>> call(File params) async {
    return await repository.uploadBannerImage(params);
  }
}
