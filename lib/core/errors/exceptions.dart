// For Handling App Exceptions
abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

// Thrown when a remote API call fails.
class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

// Thrown when a cache read/write operation fails.
class CacheException extends AppException {
  const CacheException([super.message = 'Cache operation failed']);
}

// Thrown when there is no network connectivity.
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}
