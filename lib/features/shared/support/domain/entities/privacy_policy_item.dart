import 'package:equatable/equatable.dart';

class PrivacyPolicyItem extends Equatable {
  final String id;
  final String title;
  final String content;
  final String version;
  final bool isActive;

  const PrivacyPolicyItem({
    required this.id,
    required this.title,
    required this.content,
    required this.version,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, title, content, version, isActive];
}
