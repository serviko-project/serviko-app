import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/category_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_application_usecase.dart';

// Provider onboarding repository
abstract class ProviderOnboardingRepository {
  Future<Either<Failure, ProviderProfileEntity>> submitApplication(
    SubmitApplicationParams params,
  );

  Future<Either<Failure, ProviderProfileEntity>> getMyProviderProfile();

  Future<Either<Failure, ProviderDocumentEntity>> uploadDocument({
    required String documentType,
    required File file,
  });

  Future<Either<Failure, void>> deleteDocument(String documentId);

  Future<Either<Failure, ProviderProfileEntity>> reapply(
    SubmitApplicationParams params,
  );

  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
