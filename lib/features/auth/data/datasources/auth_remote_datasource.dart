import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/features/auth/data/models/password_recovery_options_model.dart';
import 'package:serviko_app/features/auth/data/models/phone_otp_verification_model.dart';
import 'package:serviko_app/features/auth/data/models/phone_reset_otp_session_model.dart';
import 'package:serviko_app/features/auth/data/models/user_model.dart';

// Handles all Firebase Auth operations
abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> sendPasswordResetEmail({required String email});

  Future<PasswordRecoveryOptionsModel> checkRecoveryOptionsByEmail({
    required String email,
  });

  Future<PhoneResetOtpSessionModel> startPhoneResetOtp({required String email});

  Future<PhoneOtpVerificationModel> verifyPhoneResetOtp({
    required String email,
    required String sessionId,
    required String otp,
  });

  Future<void> resetPasswordWithPhoneOtp({
    required String email,
    required String verificationToken,
    required String newPassword,
  });

  Future<void> signOut();

  UserModel? getCurrentUser();

  bool get isSignedIn;

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final ApiClient _apiClient;

  static const String _recoveryOptionsPath = '/api/v1/auth/recovery-options';
  static const String _startPhoneResetOtpPath =
      '/api/v1/auth/password-reset/phone/start';
  static const String _verifyPhoneResetOtpPath =
      '/api/v1/auth/password-reset/phone/verify';
  static const String _resetPasswordPath =
      '/api/v1/auth/password-reset/phone/complete';

  AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _apiClient = apiClient;

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return UserModel.fromFirebaseUser(result.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code), code: e.code);
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return UserModel.fromFirebaseUser(result.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code), code: e.code);
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
            "886832059954-a90civr1b17jcojjti15hk9arjq43rgs.apps.googleusercontent.com",
      );

      final googleUser = await _googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = fb.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);

      return UserModel.fromFirebaseUser(result.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code), code: e.code);
    } catch (e) {
      if (e.toString().toLowerCase().contains('cancel')) {
        throw AuthException('Google sign-in cancelled', code: 'canceled');
      }
      throw AuthException(
        'An unexpected error occurred during Google sign in.',
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code), code: e.code);
    } catch (e) {
      throw AuthException('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<PasswordRecoveryOptionsModel> checkRecoveryOptionsByEmail({
    required String email,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        _recoveryOptionsPath,
        data: {'email': email.trim()},
      );

      return PasswordRecoveryOptionsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AuthException(_mapDioError(e), code: 'recovery-options-failed');
    }
  }

  @override
  Future<PhoneResetOtpSessionModel> startPhoneResetOtp({
    required String email,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        _startPhoneResetOtpPath,
        data: {'email': email.trim()},
      );

      return PhoneResetOtpSessionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AuthException(_mapDioError(e), code: 'start-phone-otp-failed');
    }
  }

  @override
  Future<PhoneOtpVerificationModel> verifyPhoneResetOtp({
    required String email,
    required String sessionId,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        _verifyPhoneResetOtpPath,
        data: {
          'email': email.trim(),
          'reset_session_id': sessionId,
          'otp': otp,
        },
      );

      return PhoneOtpVerificationModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AuthException(_mapDioError(e), code: 'verify-phone-otp-failed');
    }
  }

  @override
  Future<void> resetPasswordWithPhoneOtp({
    required String email,
    required String verificationToken,
    required String newPassword,
  }) async {
    try {
      await _apiClient.dio.post(
        _resetPasswordPath,
        data: {
          'email': email.trim(),
          'verification_token': verificationToken,
          'new_password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw AuthException(_mapDioError(e), code: 'phone-password-reset-failed');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code), code: e.code);
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(
      (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
    );
  }

  // Maps Dio errors to user-friendly messages
  String _mapDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) {
        return detail;
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return 'Unable to complete this request. Please try again.';
  }

  // Maps Firebase error codes
  String _mapFirebaseError(String code) {
    return switch (code) {
      'email-already-in-use' => 'This email is already registered',
      'invalid-email' => 'Please enter a valid email address',
      'operation-not-allowed' => 'This sign-in method is not enabled',
      'weak-password' => 'Password is too weak. Use at least 6 characters',
      'user-disabled' => 'This account has been disabled',
      'user-not-found' => 'No account found with this email',
      'wrong-password' => 'Incorrect password',
      'invalid-credential' => 'Invalid email or password',
      'too-many-requests' => 'Too many attempts. Please try again later',
      'network-request-failed' => 'Network error. Check your connection',
      _ => 'An unexpected error occurred. Please try again',
    };
  }
}
