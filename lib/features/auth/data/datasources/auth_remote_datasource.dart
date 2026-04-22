import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
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

  Future<void> signOut();

  UserModel? getCurrentUser();

  bool get isSignedIn;

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

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
