import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/auth/domain/entities/user_entity.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
part 'google_sign_in_state.dart';

// Manages Google sign-in flow
class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  final GoogleSignInUseCase _googleSignInUseCase;

  GoogleSignInCubit({required GoogleSignInUseCase googleSignInUseCase})
    : _googleSignInUseCase = googleSignInUseCase,
      super(const GoogleSignInState());

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _googleSignInUseCase(const NoParams());

    result.fold((failure) {
      if (failure.message == 'Google sign-in cancelled') {
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, error: failure.message));
      }
    }, (user) => emit(state.copyWith(user: user)));
  }

  void clearError() => emit(state.copyWith(error: null));
}
