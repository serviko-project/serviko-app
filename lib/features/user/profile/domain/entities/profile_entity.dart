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
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final String? providerStatus;
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
    this.latitude,
    this.longitude,
    required this.isActive,
    this.providerStatus,
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
    latitude,
    longitude,
    isActive,
    providerStatus,
    createdAt,
    updatedAt,
  ];
}
