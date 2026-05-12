import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String title;
  final String icon;
  final String? description;
  final String status;
  final int providerCount;

  const CategoryEntity({
    required this.id,
    required this.title,
    required this.icon,
    this.description,
    required this.status,
    required this.providerCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    icon,
    description,
    status,
    providerCount,
  ];
}
