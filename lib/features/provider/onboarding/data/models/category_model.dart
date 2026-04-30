import 'package:serviko_app/features/provider/onboarding/domain/entities/category_entity.dart';

// Category model
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.title,
    required super.icon,
    super.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String?,
    );
  }
}
