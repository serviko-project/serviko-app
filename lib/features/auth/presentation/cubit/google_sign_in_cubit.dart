import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/auth/domain/entities/user_entity.dart';
import 'package:serviko_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:serviko_app/core/usecases/usecase.dart';

// Google sign-in state
class GoogleSignInState extends Equatable {
  final bool isLoading;
  final String? error;
  final UserEntity? user;

  const GoogleSignInState({this.isLoading = false, this.error, this.user});

  GoogleSignInState copyWith({
    bool? isLoading,
    String? error,
    UserEntity? user,
  }) => GoogleSignInState(
    isLoading: isLoading ?? this.isLoading,
    error: error,
    user: user,
  );

  @override
  List<Object?> get props => [isLoading, error, user];
}

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
    }, (user) => emit(state.copyWith(isLoading: false, user: user)));
  }

  void clearError() => emit(state.copyWith(error: null));
}
