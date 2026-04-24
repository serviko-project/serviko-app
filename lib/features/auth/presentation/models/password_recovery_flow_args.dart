import 'package:equatable/equatable.dart';

// Argument classes for password recovery flow screens
class ChooseResetMethodArgs extends Equatable {
  final String email;
  final String maskedEmail;
  final bool hasPhoneRecovery;
  final String? maskedPhone;

  const ChooseResetMethodArgs({
    required this.email,
    required this.maskedEmail,
    required this.hasPhoneRecovery,
    this.maskedPhone,
  });

  @override
  List<Object?> get props => [
    email,
    maskedEmail,
    hasPhoneRecovery,
    maskedPhone,
  ];
}

// OTP verification screen arguments
class OtpVerificationArgs extends Equatable {
  final String email;
  final String? maskedPhone;
  final String sessionId;
  final int resendCooldownSeconds;

  const OtpVerificationArgs({
    required this.email,
    this.maskedPhone,
    required this.sessionId,
    required this.resendCooldownSeconds,
  });

  @override
  List<Object?> get props => [
    email,
    maskedPhone,
    sessionId,
    resendCooldownSeconds,
  ];
}

// Create new password screen arguments
class CreateNewPasswordArgs extends Equatable {
  final String email;
  final String verificationToken;

  const CreateNewPasswordArgs({
    required this.email,
    required this.verificationToken,
  });

  @override
  List<Object?> get props => [email, verificationToken];
}
