import 'package:equatable/equatable.dart';

// Represents a User
class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;

  const UserEntity({required this.uid, this.email, this.displayName});

  @override
  List<Object?> get props => [uid, email, displayName];
}
