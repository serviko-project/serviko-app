import 'package:equatable/equatable.dart';

class PhoneResetOtpSessionEntity extends Equatable {
  final String email;
  final String sessionId;
  final int expiresInSeconds;
  final int resendCooldownSeconds;
  final String? maskedPhone;

  const PhoneResetOtpSessionEntity({
    required this.email,
    required this.sessionId,
    required this.expiresInSeconds,
    required this.resendCooldownSeconds,
    this.maskedPhone,
  });

  @override
  List<Object?> get props => [
    email,
    sessionId,
    expiresInSeconds,
    resendCooldownSeconds,
    maskedPhone,
  ];
}
