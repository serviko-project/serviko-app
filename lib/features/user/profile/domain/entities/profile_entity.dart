import 'package:equatable/equatable.dart';

// User Profile Entity
class UserProfileEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profileImageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.profileImageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    phoneNumber,
    dateOfBirth,
    gender,
    profileImageUrl,
    isActive,
    createdAt,
    updatedAt,
  ];
}
