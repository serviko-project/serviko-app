import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/domain/models/token_response.dart';

abstract class CommunicationRepository {
  Future<Either<Failure, TokenResponse>> getToken();

  Future<Either<Failure, List<ProviderDirectoryEntity>>> getProviderDirectory();
}
