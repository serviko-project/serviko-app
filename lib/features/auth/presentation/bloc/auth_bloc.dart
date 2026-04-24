import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/auth/domain/entities/user_entity.dart';
import 'package:serviko_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:serviko_app/features/profile/domain/usecases/get_my_profile_usecase.dart';
part 'auth_events.dart';
part 'auth_states.dart';

// --- Auth Bloc ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  final GetMyProfileUseCase? _getMyProfileUseCase;
  late final StreamSubscription<UserEntity?> _authSub;

  AuthBloc({
    required AuthRepository repository,
    GetMyProfileUseCase? getMyProfileUseCase,
  }) : _repository = repository,
       _getMyProfileUseCase = getMyProfileUseCase,
       super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthProfileCompleted>(_onProfileCompleted);
    on<AuthOnboardingCompleted>(_onOnboardingCompleted);

    // Listen to Firebase auth state changes
    _authSub = _repository.authStateChanges.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _repository.getCurrentUser();
    if (user != null) {
      final isNew = await _checkIsNewUser(user.uid);
      emit(AuthAuthenticated(user, isNewUser: isNew));
    } else {
      final onboardingDone = await _repository.isOnboardingCompleted();
      emit(AuthUnauthenticated(isOnboardingCompleted: onboardingDone));
    }
  }

  Future<void> _onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      final isNew = await _checkIsNewUser(event.user!.uid);
      emit(AuthAuthenticated(event.user!, isNewUser: isNew));
    } else {
      final onboardingDone = await _repository.isOnboardingCompleted();
      emit(AuthUnauthenticated(isOnboardingCompleted: onboardingDone));
    }
  }

  // Checks if the user is new
  Future<bool> _checkIsNewUser(String uid) async {
    final locallyCompleted = await _repository.isProfileCompleted(uid);
    if (locallyCompleted) return false;

    if (_getMyProfileUseCase != null) {
      final result = await _getMyProfileUseCase(const NoParams());
      return result.fold((_) => true, (_) {
        _repository.markProfileCompleted(uid);
        return false;
      });
    }

    return true;
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.signOut();
  }

  // Marks profile as completed
  Future<void> _onProfileCompleted(
    AuthProfileCompleted event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      await _repository.markProfileCompleted(currentState.user.uid);
      emit(AuthAuthenticated(currentState.user, isNewUser: false));
    }
  }

  // Marks onboarding as completed
  Future<void> _onOnboardingCompleted(
    AuthOnboardingCompleted event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.markOnboardingCompleted();
    if (state is AuthUnauthenticated) {
      emit(const AuthUnauthenticated(isOnboardingCompleted: true));
    }
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }
}
