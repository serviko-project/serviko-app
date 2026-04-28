import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/auth/domain/entities/password_recovery_options_entity.dart';
import 'package:serviko_app/features/user/auth/domain/entities/phone_reset_otp_session_entity.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/check_recovery_options_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/start_phone_reset_otp_usecase.dart';
part 'forgot_password_state.dart';

// Manages forgot password flow for email lookup, email reset and phone OTP.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final CheckRecoveryOptionsUseCase _checkRecoveryOptionsUseCase;
  final StartPhoneResetOtpUseCase _startPhoneResetOtpUseCase;

  ForgotPasswordCubit({
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required CheckRecoveryOptionsUseCase checkRecoveryOptionsUseCase,
    required StartPhoneResetOtpUseCase startPhoneResetOtpUseCase,
  }) : _checkRecoveryOptionsUseCase = checkRecoveryOptionsUseCase,
       _startPhoneResetOtpUseCase = startPhoneResetOtpUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       super(const ForgotPasswordState());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  // Checks if the email exists and what recovery options are available
  Future<void> checkRecoveryOptions() async {
    if (formKey.currentState != null) {
      if (!formKey.currentState!.validate()) return;
    } else if (emailController.text.trim().isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        isLookupLoading: true,
        error: null,
        clearRecoveryOptions: true,
      ),
    );

    final result = await _checkRecoveryOptionsUseCase(
      CheckRecoveryOptionsParams(email: emailController.text.trim()),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLookupLoading: false,
          error: failure.message,
          clearRecoveryOptions: true,
        ),
      ),
      (options) => emit(
        state.copyWith(
          isLookupLoading: false,
          recoveryOptions: options,
          error: options.accountExists ? null : 'Email is not registered',
        ),
      ),
    );
  }

  // Sends password reset email if that option is available
  Future<void> sendResetEmailFor(String email) async {
    emit(
      state.copyWith(isActionLoading: true, error: null, isEmailSent: false),
    );

    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: email.trim()),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isActionLoading: false, error: failure.message)),
      (_) => emit(state.copyWith(isActionLoading: false, isEmailSent: true)),
    );
  }

  // Starts phone OTP flow if that option is available
  Future<void> startPhoneResetOtp(String email) async {
    emit(
      state.copyWith(isActionLoading: true, error: null, clearOtpSession: true),
    );

    final result = await _startPhoneResetOtpUseCase(
      StartPhoneResetOtpParams(email: email.trim()),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isActionLoading: false, error: failure.message)),
      (session) =>
          emit(state.copyWith(isActionLoading: false, otpSession: session)),
    );
  }

  void clearError() => emit(state.copyWith(error: null));

  void clearRecoveryOptions() =>
      emit(state.copyWith(clearRecoveryOptions: true));

  void clearEmailSentFlag() => emit(state.copyWith(isEmailSent: false));

  void clearOtpSession() => emit(state.copyWith(clearOtpSession: true));

  void updateSelectedMethod(int index) =>
      emit(state.copyWith(selectedMethodIndex: index));

  @override
  Future<void> close() {
    emailController.dispose();
    emailFocusNode.dispose();
    return super.close();
  }
}
