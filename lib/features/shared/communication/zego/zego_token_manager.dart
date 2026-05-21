import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/shared/communication/domain/repositories/communication_repository.dart';

class ZegoTokenManager {
  ZegoTokenManager(this._repository);

  final CommunicationRepository _repository;

  static const Duration _refreshBuffer = Duration(minutes: 5);

  String? _token;
  DateTime? _expiresAt;

  Future<Either<Failure, String>> getValidToken() async {
    final now = DateTime.now();
    final expiresAt = _expiresAt;
    final token = _token;
    if (token != null &&
        expiresAt != null &&
        expiresAt.subtract(_refreshBuffer).isAfter(now)) {
      return Right(token);
    }

    final response = await _repository.getToken();
    return response.map((tokenResponse) {
      _token = tokenResponse.token;
      _expiresAt = now.add(Duration(seconds: tokenResponse.expiresIn));
      return tokenResponse.token;
    });
  }

  void clear() {
    _token = null;
    _expiresAt = null;
  }
}
