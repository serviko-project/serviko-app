part of 'google_sign_in_cubit.dart';

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
