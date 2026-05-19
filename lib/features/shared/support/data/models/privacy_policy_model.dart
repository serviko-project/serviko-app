import 'package:serviko_app/features/shared/support/domain/entities/privacy_policy_item.dart';

class PrivacyPolicyModel extends PrivacyPolicyItem {
  const PrivacyPolicyModel({
    required super.id,
    required super.title,
    required super.content,
    required super.version,
    required super.isActive,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      version: json['version'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'version': version,
      'is_active': isActive,
    };
  }
}
