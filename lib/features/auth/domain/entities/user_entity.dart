import 'package:equatable/equatable.dart';

// Represents a User
class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool emailVerified;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.emailVerified = false,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    phoneNumber,
    emailVerified,
  ];
}
