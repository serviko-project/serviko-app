import 'package:serviko_app/features/auth/domain/entities/phone_reset_otp_session_entity.dart';

class PhoneResetOtpSessionModel extends PhoneResetOtpSessionEntity {
  const PhoneResetOtpSessionModel({
    required super.email,
    required super.sessionId,
    required super.expiresInSeconds,
    required super.resendCooldownSeconds,
    super.maskedPhone,
  });

  factory PhoneResetOtpSessionModel.fromJson(Map<String, dynamic> json) {
    return PhoneResetOtpSessionModel(
      email: json['email'] as String? ?? '',
      sessionId: json['reset_session_id'] as String? ?? '',
      expiresInSeconds: json['expires_in'] as int? ?? 300,
      resendCooldownSeconds: json['resend_available_in'] as int? ?? 60,
      maskedPhone: json['masked_phone'] as String?,
    );
  }
}
