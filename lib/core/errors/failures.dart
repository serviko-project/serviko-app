import 'package:equatable/equatable.dart';

// To handle Failures in App
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// Failure originating from a remote API call.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

// Failure originating from local cache / storage.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Failure due to missing network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

// Failure originating from Firebase Auth.
class AuthFailure extends Failure {
  const AuthFailure(super.message, {this.code});

  final String? code;

  @override
  List<Object?> get props => [message, code];
}

// Generic Unexpected failure.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
