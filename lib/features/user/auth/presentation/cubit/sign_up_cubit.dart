import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/auth/domain/entities/user_entity.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/sign_up_usecase.dart';
part 'sign_up_state.dart';

// Manages sign-up form state and Firebase auth
class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase _signUpUseCase;

  SignUpCubit({required SignUpUseCase signUpUseCase})
    : _signUpUseCase = signUpUseCase,
      super(const SignUpState());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void toggleAgreeToTerms(bool value) =>
      emit(state.copyWith(agreeToTerms: value));

  Future<void> signUp() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(isLoading: true, error: null));

    final result = await _signUpUseCase(
      SignUpParams(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (user) => emit(state.copyWith(user: user)),
    );
  }

  void clearError() => emit(state.copyWith(error: null));

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    return super.close();
  }
}
