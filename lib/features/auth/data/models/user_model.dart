import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:serviko_app/features/auth/domain/entities/user_entity.dart';

// Maps Firebase User to UserModel
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.email,
    super.displayName,
    super.photoUrl,
    super.phoneNumber,
    super.emailVerified,
  });

  factory UserModel.fromFirebaseUser(fb.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      emailVerified: user.emailVerified,
    );
  }
}
