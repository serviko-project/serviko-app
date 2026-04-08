import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// OTP verification state
class OtpState {
  final int secondsRemaining;
  final bool canResend;

  const OtpState({this.secondsRemaining = 60, this.canResend = false});

  OtpState copyWith({int? secondsRemaining, bool? canResend}) => OtpState(
    secondsRemaining: secondsRemaining ?? this.secondsRemaining,
    canResend: canResend ?? this.canResend,
  );
}

// Manages OTP timer and resend logic
class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(const OtpState()) {
    _startTimer();
  }

  final otpController = TextEditingController();
  Timer? _timer;

  void _startTimer() {
    emit(const OtpState(secondsRemaining: 60, canResend: false));
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

  void resendOtp() {
    if (!state.canResend) return;
    // TODO: Resend OTP via Firebase Auth
    _startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    otpController.dispose();
    return super.close();
  }
}
