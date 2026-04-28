import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/auth/domain/entities/phone_reset_otp_session_entity.dart';
import 'package:serviko_app/features/user/auth/domain/repositories/auth_repository.dart';

class StartPhoneResetOtpUseCase
    extends UseCase<PhoneResetOtpSessionEntity, StartPhoneResetOtpParams> {
  final AuthRepository repository;

  StartPhoneResetOtpUseCase(this.repository);

  @override
  Future<Either<Failure, PhoneResetOtpSessionEntity>> call(
    StartPhoneResetOtpParams params,
  ) {
    return repository.startPhoneResetOtp(email: params.email);
  }
}

class StartPhoneResetOtpParams extends Equatable {
  final String email;

  const StartPhoneResetOtpParams({required this.email});

  @override
  List<Object?> get props => [email];
}
