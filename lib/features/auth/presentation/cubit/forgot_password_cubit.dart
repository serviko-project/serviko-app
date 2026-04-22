import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/auth/domain/usecases/forgot_password_usecase.dart';

// Forgot password state
class ForgotPasswordState extends Equatable {
  final bool isLoading;
  final bool isEmailSent;
  final String? error;
  final int selectedMethodIndex;

  const ForgotPasswordState({
    this.isLoading = false,
    this.isEmailSent = false,
    this.error,
    this.selectedMethodIndex = 0,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? isEmailSent,
    String? error,
    int? selectedMethodIndex,
  }) => ForgotPasswordState(
    isLoading: isLoading ?? this.isLoading,
    isEmailSent: isEmailSent ?? this.isEmailSent,
    error: error,
    selectedMethodIndex: selectedMethodIndex ?? this.selectedMethodIndex,
  );

  @override
  List<Object?> get props => [
    isLoading,
    isEmailSent,
    error,
    selectedMethodIndex,
  ];
}

// Manages forgot password flow with Firebase email reset
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordCubit({required ForgotPasswordUseCase forgotPasswordUseCase})
    : _forgotPasswordUseCase = forgotPasswordUseCase,
      super(const ForgotPasswordState());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  Future<void> sendResetEmail() async {
    if (formKey.currentState != null) {
      if (!formKey.currentState!.validate()) return;
    } else if (emailController.text.trim().isEmpty) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await _forgotPasswordUseCase(
        ForgotPasswordParams(email: emailController.text.trim()),
      );

      result.fold(
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)),
        (_) => emit(state.copyWith(isLoading: false, isEmailSent: true)),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'An unexpected error occurred'),
      );
    }
  }

  void clearError() => emit(state.copyWith(error: null));

  void updateSelectedMethod(int index) =>
      emit(state.copyWith(selectedMethodIndex: index));

  @override
  Future<void> close() {
    emailController.dispose();
    emailFocusNode.dispose();
    return super.close();
  }
}
