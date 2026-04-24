import 'package:serviko_app/features/auth/domain/entities/password_recovery_options_entity.dart';

class PasswordRecoveryOptionsModel extends PasswordRecoveryOptionsEntity {
  const PasswordRecoveryOptionsModel({
    required super.accountExists,
    required super.email,
    required super.maskedEmail,
    required super.hasPhoneRecovery,
    super.maskedPhone,
  });

  factory PasswordRecoveryOptionsModel.fromJson(Map<String, dynamic> json) {
    return PasswordRecoveryOptionsModel(
      accountExists: json['account_exists'] as bool? ?? true,
      email: json['email'] as String? ?? '',
      maskedEmail: json['masked_email'] as String? ?? '',
      hasPhoneRecovery: json['has_phone_method'] as bool? ?? false,
      maskedPhone: json['masked_phone'] as String?,
    );
  }
}
