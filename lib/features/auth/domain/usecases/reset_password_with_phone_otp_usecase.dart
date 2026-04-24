import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordWithPhoneOtpUseCase
    extends UseCase<void, ResetPasswordWithPhoneOtpParams> {
  final AuthRepository repository;

  ResetPasswordWithPhoneOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordWithPhoneOtpParams params) {
    return repository.resetPasswordWithPhoneOtp(
      email: params.email,
      verificationToken: params.verificationToken,
      newPassword: params.newPassword,
    );
  }
}

class ResetPasswordWithPhoneOtpParams extends Equatable {
  final String email;
  final String verificationToken;
  final String newPassword;

  const ResetPasswordWithPhoneOtpParams({
    required this.email,
    required this.verificationToken,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, verificationToken, newPassword];
}
