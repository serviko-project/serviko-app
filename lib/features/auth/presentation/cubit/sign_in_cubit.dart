import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/auth/domain/entities/user_entity.dart';
import 'package:serviko_app/features/auth/domain/usecases/sign_in_usecase.dart';

// Sign-in form state
class SignInState extends Equatable {
  final bool rememberMe;
  final bool isLoading;
  final String? error;
  final UserEntity? user;

  const SignInState({
    this.rememberMe = false,
    this.isLoading = false,
    this.error,
    this.user,
  });

  SignInState copyWith({
    bool? rememberMe,
    bool? isLoading,
    String? error,
    UserEntity? user,
  }) => SignInState(
    rememberMe: rememberMe ?? this.rememberMe,
    isLoading: isLoading ?? this.isLoading,
    error: error,
    user: user,
  );

  @override
  List<Object?> get props => [rememberMe, isLoading, error, user];
}

// Manages sign-in form state and Firebase auth
class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase _signInUseCase;

  SignInCubit({required SignInUseCase signInUseCase})
    : _signInUseCase = signInUseCase,
      super(const SignInState());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void toggleRememberMe(bool value) => emit(state.copyWith(rememberMe: value));

  Future<void> signIn() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(isLoading: true, error: null));

    final result = await _signInUseCase(
      SignInParams(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (user) => emit(state.copyWith(isLoading: false, user: user)),
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
