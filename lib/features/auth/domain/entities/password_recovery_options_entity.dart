import 'package:equatable/equatable.dart';

class PasswordRecoveryOptionsEntity extends Equatable {
  final bool accountExists;
  final String email;
  final String maskedEmail;
  final bool hasPhoneRecovery;
  final String? maskedPhone;

  const PasswordRecoveryOptionsEntity({
    required this.accountExists,
    required this.email,
    required this.maskedEmail,
    required this.hasPhoneRecovery,
    this.maskedPhone,
  });

  @override
  List<Object?> get props => [
    accountExists,
    email,
    maskedEmail,
    hasPhoneRecovery,
    maskedPhone,
  ];
}
