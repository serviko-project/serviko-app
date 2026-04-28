part of 'auth_bloc.dart';

// --- Auth States ---
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  final bool isNewUser;

  const AuthAuthenticated(this.user, {this.isNewUser = false});

  @override
  List<Object?> get props => [user, isNewUser];
}

class AuthUnauthenticated extends AuthState {
  final bool isOnboardingCompleted;

  const AuthUnauthenticated({this.isOnboardingCompleted = false});

  @override
  List<Object?> get props => [isOnboardingCompleted];
}
