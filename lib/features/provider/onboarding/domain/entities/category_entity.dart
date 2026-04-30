import 'package:equatable/equatable.dart';

// Service category entity
class CategoryEntity extends Equatable {
  final String id;
  final String title;
  final String icon;
  final String? description;

  const CategoryEntity({
    required this.id,
    required this.title,
    required this.icon,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, icon, description];
}
