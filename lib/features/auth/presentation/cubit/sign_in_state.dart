part of 'sign_in_cubit.dart';

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
