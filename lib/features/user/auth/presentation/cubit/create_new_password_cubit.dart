import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/reset_password_with_phone_otp_usecase.dart';
part 'create_new_password_state.dart';

// Manages create new password form state
class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  final ResetPasswordWithPhoneOtpUseCase _resetPasswordWithPhoneOtpUseCase;

  CreateNewPasswordCubit({
    required ResetPasswordWithPhoneOtpUseCase resetPasswordWithPhoneOtpUseCase,
  }) : _resetPasswordWithPhoneOtpUseCase = resetPasswordWithPhoneOtpUseCase,
       super(const CreateNewPasswordState());

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  Future<void> submitResetPassword({
    required String email,
    required String verificationToken,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));

    final result = await _resetPasswordWithPhoneOtpUseCase(
      ResetPasswordWithPhoneOtpParams(
        email: email,
        verificationToken: verificationToken,
        newPassword: passwordController.text.trim(),
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }

  void clearError() => emit(state.copyWith(error: null));

  void clearSuccessFlag() => emit(state.copyWith(isSuccess: false));

  @override
  Future<void> close() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    return super.close();
  }
}
