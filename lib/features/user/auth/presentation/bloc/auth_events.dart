part of 'auth_bloc.dart';

// --- Auth Events ---
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthProfileCompleted extends AuthEvent {
  const AuthProfileCompleted();
}

class AuthOnboardingCompleted extends AuthEvent {
  const AuthOnboardingCompleted();
}
