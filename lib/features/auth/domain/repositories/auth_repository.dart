import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/auth/domain/entities/password_recovery_options_entity.dart';
import 'package:serviko_app/features/auth/domain/entities/phone_otp_verification_entity.dart';
import 'package:serviko_app/features/auth/domain/entities/phone_reset_otp_session_entity.dart';
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

  Future<Either<Failure, PasswordRecoveryOptionsEntity>>
  checkRecoveryOptionsByEmail({required String email});

  Future<Either<Failure, PhoneResetOtpSessionEntity>> startPhoneResetOtp({
    required String email,
  });

  Future<Either<Failure, PhoneOtpVerificationEntity>> verifyPhoneResetOtp({
    required String email,
    required String sessionId,
    required String otp,
  });

  Future<Either<Failure, void>> resetPasswordWithPhoneOtp({
    required String email,
    required String verificationToken,
    required String newPassword,
  });

  Future<Either<Failure, void>> signOut();

  UserEntity? getCurrentUser();

  bool get isSignedIn;

  Stream<UserEntity?> get authStateChanges;

  Future<bool> isProfileCompleted(String uid);

  Future<void> markProfileCompleted(String uid);

  Future<bool> isOnboardingCompleted();

  Future<void> markOnboardingCompleted();
}
