import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:serviko_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:serviko_app/features/auth/domain/entities/password_recovery_options_entity.dart';
import 'package:serviko_app/features/auth/domain/entities/phone_otp_verification_entity.dart';
import 'package:serviko_app/features/auth/domain/entities/phone_reset_otp_session_entity.dart';
import 'package:serviko_app/features/auth/domain/entities/user_entity.dart';
import 'package:serviko_app/features/auth/domain/repositories/auth_repository.dart';

// Auth Repo Implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, PasswordRecoveryOptionsEntity>>
  checkRecoveryOptionsByEmail({required String email}) async {
    try {
      final options = await remoteDataSource.checkRecoveryOptionsByEmail(
        email: email,
      );
      return Right(options);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, PhoneResetOtpSessionEntity>> startPhoneResetOtp({
    required String email,
  }) async {
    try {
      final session = await remoteDataSource.startPhoneResetOtp(email: email);
      return Right(session);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, PhoneOtpVerificationEntity>> verifyPhoneResetOtp({
    required String email,
    required String sessionId,
    required String otp,
  }) async {
    try {
      final verification = await remoteDataSource.verifyPhoneResetOtp(
        email: email,
        sessionId: sessionId,
        otp: otp,
      );
      return Right(verification);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, void>> resetPasswordWithPhoneOtp({
    required String email,
    required String verificationToken,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPasswordWithPhoneOtp(
        email: email,
        verificationToken: verificationToken,
        newPassword: newPassword,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  UserEntity? getCurrentUser() => remoteDataSource.getCurrentUser();

  @override
  bool get isSignedIn => remoteDataSource.isSignedIn;

  @override
  Stream<UserEntity?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<bool> isProfileCompleted(String uid) =>
      localDataSource.isProfileCompleted(uid);

  @override
  Future<void> markProfileCompleted(String uid) =>
      localDataSource.markProfileCompleted(uid);

  @override
  Future<bool> isOnboardingCompleted() =>
      localDataSource.isOnboardingCompleted();

  @override
  Future<void> markOnboardingCompleted() =>
      localDataSource.markOnboardingCompleted();
}
