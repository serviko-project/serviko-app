import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/auth/domain/entities/phone_otp_verification_entity.dart';
import 'package:serviko_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyPhoneResetOtpUseCase
    extends UseCase<PhoneOtpVerificationEntity, VerifyPhoneResetOtpParams> {
  final AuthRepository repository;

  VerifyPhoneResetOtpUseCase(this.repository);

  @override
  Future<Either<Failure, PhoneOtpVerificationEntity>> call(
    VerifyPhoneResetOtpParams params,
  ) {
    return repository.verifyPhoneResetOtp(
      email: params.email,
      sessionId: params.sessionId,
      otp: params.otp,
    );
  }
}

class VerifyPhoneResetOtpParams extends Equatable {
  final String email;
  final String sessionId;
  final String otp;

  const VerifyPhoneResetOtpParams({
    required this.email,
    required this.sessionId,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, sessionId, otp];
}
