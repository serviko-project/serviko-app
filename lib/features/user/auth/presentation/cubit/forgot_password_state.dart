part of 'forgot_password_cubit.dart';

// Forgot password state
class ForgotPasswordState extends Equatable {
  final bool isLookupLoading;
  final bool isActionLoading;
  final bool isEmailSent;
  final String? error;
  final int selectedMethodIndex;
  final PasswordRecoveryOptionsEntity? recoveryOptions;
  final PhoneResetOtpSessionEntity? otpSession;

  const ForgotPasswordState({
    this.isLookupLoading = false,
    this.isActionLoading = false,
    this.isEmailSent = false,
    this.error,
    this.selectedMethodIndex = 0,
    this.recoveryOptions,
    this.otpSession,
  });

  ForgotPasswordState copyWith({
    bool? isLookupLoading,
    bool? isActionLoading,
    bool? isEmailSent,
    String? error,
    int? selectedMethodIndex,
    PasswordRecoveryOptionsEntity? recoveryOptions,
    PhoneResetOtpSessionEntity? otpSession,
    bool clearRecoveryOptions = false,
    bool clearOtpSession = false,
  }) => ForgotPasswordState(
    isLookupLoading: isLookupLoading ?? this.isLookupLoading,
    isActionLoading: isActionLoading ?? this.isActionLoading,
    isEmailSent: isEmailSent ?? this.isEmailSent,
    error: error,
    selectedMethodIndex: selectedMethodIndex ?? this.selectedMethodIndex,
    recoveryOptions: clearRecoveryOptions
        ? null
        : (recoveryOptions ?? this.recoveryOptions),
    otpSession: clearOtpSession ? null : (otpSession ?? this.otpSession),
  );

  @override
  List<Object?> get props => [
    isLookupLoading,
    isActionLoading,
    isEmailSent,
    error,
    selectedMethodIndex,
    recoveryOptions,
    otpSession,
  ];
}
