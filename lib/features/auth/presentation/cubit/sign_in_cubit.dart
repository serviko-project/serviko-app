import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Sign-in form state
class SignInState {
  const SignInState({this.rememberMe = false});

  final bool rememberMe;

  SignInState copyWith({bool? rememberMe}) =>
      SignInState(rememberMe: rememberMe ?? this.rememberMe);
}

// Manages sign-in form state
class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void toggleRememberMe(bool value) => emit(state.copyWith(rememberMe: value));

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    return super.close();
  }
}
