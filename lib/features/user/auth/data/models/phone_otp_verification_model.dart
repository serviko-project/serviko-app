import 'package:serviko_app/features/user/auth/domain/entities/phone_otp_verification_entity.dart';

class PhoneOtpVerificationModel extends PhoneOtpVerificationEntity {
  const PhoneOtpVerificationModel({
    required super.verificationToken,
    required super.expiresInSeconds,
  });

  factory PhoneOtpVerificationModel.fromJson(Map<String, dynamic> json) {
    return PhoneOtpVerificationModel(
      verificationToken: json['verification_token'] as String? ?? '',
      expiresInSeconds: json['expires_in_seconds'] as int? ?? 300,
    );
  }
}
