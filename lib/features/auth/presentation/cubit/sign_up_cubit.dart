import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Sign-up form state
class SignUpState {
  const SignUpState({this.agreeToTerms = false});

  final bool agreeToTerms;

  SignUpState copyWith({bool? agreeToTerms}) =>
      SignUpState(agreeToTerms: agreeToTerms ?? this.agreeToTerms);
}

// Manages sign-up form state
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void toggleAgreeToTerms(bool value) =>
      emit(state.copyWith(agreeToTerms: value));

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    return super.close();
  }
}
