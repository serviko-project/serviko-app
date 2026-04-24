import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/auth/domain/usecases/start_phone_reset_otp_usecase.dart';
import 'package:serviko_app/features/auth/domain/usecases/verify_phone_reset_otp_usecase.dart';
part 'otp_state.dart';

// Manages OTP timer, verification and resend logic.
class OtpCubit extends Cubit<OtpState> {
  final VerifyPhoneResetOtpUseCase _verifyPhoneResetOtpUseCase;
  final StartPhoneResetOtpUseCase _startPhoneResetOtpUseCase;

  OtpCubit({
    required VerifyPhoneResetOtpUseCase verifyPhoneResetOtpUseCase,
    required StartPhoneResetOtpUseCase startPhoneResetOtpUseCase,
    required String initialSessionId,
    required int initialCooldownSeconds,
  }) : _verifyPhoneResetOtpUseCase = verifyPhoneResetOtpUseCase,
       _startPhoneResetOtpUseCase = startPhoneResetOtpUseCase,
       super(
         OtpState(
           sessionId: initialSessionId,
           secondsRemaining: initialCooldownSeconds,
           canResend: initialCooldownSeconds <= 0,
         ),
       ) {
    _startTimer(initialCooldownSeconds);
  }

  final otpController = TextEditingController();
  Timer? _timer;

  // Starts or restarts the OTP resend timer
  void _startTimer(int seconds) {
    emit(state.copyWith(secondsRemaining: seconds, canResend: seconds <= 0));

    if (seconds <= 0) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining <= 1) {
        emit(state.copyWith(secondsRemaining: 0, canResend: true));
        timer.cancel();
      } else {
        emit(state.copyWith(secondsRemaining: state.secondsRemaining - 1));
      }
    });
  }

  // Resends OTP method
  Future<void> resendOtp({required String email}) async {
    if (!state.canResend) return;

    emit(state.copyWith(isResending: true, error: null));

    final result = await _startPhoneResetOtpUseCase(
      StartPhoneResetOtpParams(email: email.trim()),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isResending: false, error: failure.message)),
      (session) {
        emit(
          state.copyWith(
            isResending: false,
            sessionId: session.sessionId,
            error: null,
            clearVerificationToken: true,
          ),
        );
        _startTimer(session.resendCooldownSeconds);
      },
    );
  }

  // Verifies the entered OTP
  Future<void> verifyOtp({required String email}) async {
    if (otpController.text.length < 4) {
      emit(state.copyWith(error: 'Please enter the complete OTP'));
      return;
    }

    emit(state.copyWith(isVerifying: true, error: null));

    final result = await _verifyPhoneResetOtpUseCase(
      VerifyPhoneResetOtpParams(
        email: email.trim(),
        sessionId: state.sessionId,
        otp: otpController.text.trim(),
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isVerifying: false, error: failure.message)),
      (verification) => emit(
        state.copyWith(
          isVerifying: false,
          verificationToken: verification.verificationToken,
        ),
      ),
    );
  }

  void clearError() => emit(state.copyWith(error: null));

  void clearVerificationToken() =>
      emit(state.copyWith(clearVerificationToken: true));

  @override
  Future<void> close() {
    _timer?.cancel();
    otpController.dispose();
    return super.close();
  }
}
