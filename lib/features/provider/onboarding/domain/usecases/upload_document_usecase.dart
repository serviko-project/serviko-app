import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';

// Uploads a document
class UploadDocumentUseCase
    extends UseCase<ProviderDocumentEntity, UploadDocumentParams> {
  final ProviderOnboardingRepository _repository;

  UploadDocumentUseCase(this._repository);

  @override
  Future<Either<Failure, ProviderDocumentEntity>> call(
    UploadDocumentParams params,
  ) {
    return _repository.uploadDocument(
      documentType: params.documentType,
      file: params.file,
    );
  }
}

// Params for document upload
class UploadDocumentParams extends Equatable {
  final String documentType;
  final File file;

  const UploadDocumentParams({required this.documentType, required this.file});

  @override
  List<Object?> get props => [documentType, file];
}
