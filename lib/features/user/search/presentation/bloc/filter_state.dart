import 'package:flutter/material.dart';
import '../../domain/models/filter_enums.dart';
import '../../../category/domain/entities/category_entity.dart';

class FilterState {
  final String? categoryId;
  final RangeValues priceRange;
  final RatingFilter rating;
  final ExperienceFilter experience;
  final List<CategoryEntity> availableCategories;

  const FilterState({
    this.categoryId,
    required this.priceRange,
    required this.rating,
    required this.experience,
    required this.availableCategories,
  });

  FilterState copyWith({
    String? categoryId,
    bool clearCategory = false,
    RangeValues? priceRange,
    RatingFilter? rating,
    ExperienceFilter? experience,
    List<CategoryEntity>? availableCategories,
  }) {
    return FilterState(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      experience: experience ?? this.experience,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }
}
