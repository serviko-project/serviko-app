import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Create new password form state
class CreateNewPasswordState {
  final bool rememberMe;

  const CreateNewPasswordState({this.rememberMe = false});

  CreateNewPasswordState copyWith({bool? rememberMe}) =>
      CreateNewPasswordState(rememberMe: rememberMe ?? this.rememberMe);
}

// Manages create new password form state
class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(const CreateNewPasswordState());

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  void toggleRememberMe(bool value) => emit(state.copyWith(rememberMe: value));

  @override
  Future<void> close() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    return super.close();
  }
}
