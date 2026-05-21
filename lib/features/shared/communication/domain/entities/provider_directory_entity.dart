import 'package:equatable/equatable.dart';

class ProviderDirectoryEntity extends Equatable {
  const ProviderDirectoryEntity({
    required this.id,
    required this.userId,
    required this.firebaseUid,
    this.name,
    this.profileImageUrl,
    this.professionalTitle,
    this.about,
    this.bannerImageUrl,
    this.categories = const [],
  });

  final String id;
  final String userId;
  final String firebaseUid;
  final String? name;
  final String? profileImageUrl;
  final String? professionalTitle;
  final String? about;
  final String? bannerImageUrl;
  final List<String> categories;

  String get displayName {
    final value = name?.trim();
    return value == null || value.isEmpty ? 'User' : value;
  }

  String get categorySummary {
    if (categories.isEmpty) return 'Serviko User';
    return categories.take(2).join(', ');
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    firebaseUid,
    name,
    profileImageUrl,
    professionalTitle,
    about,
    bannerImageUrl,
    categories,
  ];
}
