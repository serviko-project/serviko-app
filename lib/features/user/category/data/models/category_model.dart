import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.title,
    required super.icon,
    super.description,
    required super.status,
    required super.providerCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      providerCount: json['provider_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'description': description,
      'status': status,
      'provider_count': providerCount,
    };
  }
}
