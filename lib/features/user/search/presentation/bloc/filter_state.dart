import 'package:flutter/material.dart';
import '../../domain/models/filter_enums.dart';

class FilterState {
  final String category;
  final RangeValues priceRange;
  final RatingFilter rating;
  final ExperienceFilter experience;
  final List<String> availableCategories;

  const FilterState({
    required this.category,
    required this.priceRange,
    required this.rating,
    required this.experience,
    required this.availableCategories,
  });

  FilterState copyWith({
    String? category,
    RangeValues? priceRange,
    RatingFilter? rating,
    ExperienceFilter? experience,
    List<String>? availableCategories,
  }) {
    return FilterState(
      category: category ?? this.category,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      experience: experience ?? this.experience,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }
}
