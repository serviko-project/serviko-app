part of 'otp_cubit.dart';

// OTP verification state
class OtpState extends Equatable {
  final int secondsRemaining;
  final bool canResend;
  final bool isVerifying;
  final bool isResending;
  final String? error;
  final String? verificationToken;
  final String sessionId;

  const OtpState({
    this.secondsRemaining = 60,
    this.canResend = false,
    this.isVerifying = false,
    this.isResending = false,
    this.error,
    this.verificationToken,
    this.sessionId = '',
  });

  OtpState copyWith({
    int? secondsRemaining,
    bool? canResend,
    bool? isVerifying,
    bool? isResending,
    String? error,
    String? verificationToken,
    String? sessionId,
    bool clearVerificationToken = false,
  }) => OtpState(
    secondsRemaining: secondsRemaining ?? this.secondsRemaining,
    canResend: canResend ?? this.canResend,
    isVerifying: isVerifying ?? this.isVerifying,
    isResending: isResending ?? this.isResending,
    error: error,
    verificationToken: clearVerificationToken
        ? null
        : (verificationToken ?? this.verificationToken),
    sessionId: sessionId ?? this.sessionId,
  );

  @override
  List<Object?> get props => [
    secondsRemaining,
    canResend,
    isVerifying,
    isResending,
    error,
    verificationToken,
    sessionId,
  ];
}
