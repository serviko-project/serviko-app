import 'package:equatable/equatable.dart';

class PhoneOtpVerificationEntity extends Equatable {
  final String verificationToken;
  final int expiresInSeconds;

  const PhoneOtpVerificationEntity({
    required this.verificationToken,
    required this.expiresInSeconds,
  });

  @override
  List<Object?> get props => [verificationToken, expiresInSeconds];
}
