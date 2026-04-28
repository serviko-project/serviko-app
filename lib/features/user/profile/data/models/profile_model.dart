import 'package:serviko_app/features/user/profile/domain/entities/profile_entity.dart';

// User Profile Model
class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phoneNumber,
    super.dateOfBirth,
    super.gender,
    super.profileImageUrl,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static Map<String, dynamic> toCreateJson({
    required String fullName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? profileImageUrl,
  }) {
    final json = <String, dynamic>{'full_name': fullName};

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      json['phone_number'] = phoneNumber;
    }
    if (dateOfBirth != null) {
      json['date_of_birth'] = _formatDate(dateOfBirth);
    }
    if (gender != null) {
      json['gender'] = gender.toLowerCase();
    }
    if (profileImageUrl != null) {
      json['profile_image_url'] = profileImageUrl;
    }

    return json;
  }

  static Map<String, dynamic> toUpdateJson({
    String? fullName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? profileImageUrl,
  }) {
    final json = <String, dynamic>{};

    if (fullName != null) json['full_name'] = fullName;
    if (phoneNumber != null) json['phone_number'] = phoneNumber;
    if (dateOfBirth != null) json['date_of_birth'] = _formatDate(dateOfBirth);
    if (gender != null) json['gender'] = gender.toLowerCase();
    if (profileImageUrl != null) json['profile_image_url'] = profileImageUrl;

    return json;
  }

  // Format DateTime to YYYY-MM-DD
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
