import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/upload_document_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit_base.dart';

// Document upload & delete logic for the onboarding cubit
mixin OnboardingDocumentMixin on ProviderOnboardingCubitBase {
  // Pick a file and upload it
  Future<void> pickAndUploadDocument(int docNumber) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    final docType = docNumber == 1
        ? 'government_id'
        : 'professional_certificate';

    // Set uploading flag
    if (docNumber == 1) {
      emit(state.copyWith(isUploadingDoc1: true));
    } else {
      emit(state.copyWith(isUploadingDoc2: true));
    }

    final uploadResult = await uploadDocumentUseCase(
      UploadDocumentParams(documentType: docType, file: file),
    );

    uploadResult.fold(
      (failure) {
        if (docNumber == 1) {
          emit(
            state.copyWith(
              isUploadingDoc1: false,
              errorMessage: failure.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isUploadingDoc2: false,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (document) {
        if (docNumber == 1) {
          emit(
            state.copyWith(isUploadingDoc1: false, governmentIdDoc: document),
          );
        } else {
          emit(
            state.copyWith(isUploadingDoc2: false, certificateDoc: document),
          );
        }
      },
    );
  }

  // Remove an uploaded document
  Future<void> removeDocument(int docNumber) async {
    final doc = docNumber == 1 ? state.governmentIdDoc : state.certificateDoc;
    if (doc == null) return;

    final result = await deleteDocumentUseCase(doc.id);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        if (docNumber == 1) {
          emit(state.copyWith(clearGovernmentIdDoc: true));
        } else {
          emit(state.copyWith(clearCertificateDoc: true));
        }
      },
    );
  }
}
