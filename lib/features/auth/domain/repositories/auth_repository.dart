import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/auth/domain/entities/user_entity.dart';

// Auth repository
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});

  Future<Either<Failure, void>> signOut();

  UserEntity? getCurrentUser();

  bool get isSignedIn;

  Stream<UserEntity?> get authStateChanges;

  Future<bool> isProfileCompleted(String uid);

  Future<void> markProfileCompleted(String uid);

  Future<bool> isOnboardingCompleted();

  Future<void> markOnboardingCompleted();
}
