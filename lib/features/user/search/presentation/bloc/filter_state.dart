import 'package:flutter/material.dart';
import '../../domain/models/filter_enums.dart';
import '../../../category/domain/entities/category_entity.dart';

class FilterState {
  final String? categoryId;
  final RangeValues priceRange;
  final double minPrice;
  final double maxPrice;
  final RatingFilter rating;
  final ExperienceFilter experience;
  final List<CategoryEntity> availableCategories;
  final bool isLoadingPriceRange;

  const FilterState({
    this.categoryId,
    required this.priceRange,
    this.minPrice = 0.0,
    this.maxPrice = 500.0,
    required this.rating,
    required this.experience,
    required this.availableCategories,
    this.isLoadingPriceRange = false,
  });

  bool get isFiltered =>
      categoryId != null ||
      priceRange.start != minPrice ||
      priceRange.end != maxPrice ||
      rating != RatingFilter.all ||
      experience != ExperienceFilter.any;

  FilterState copyWith({
    String? categoryId,
    bool clearCategory = false,
    RangeValues? priceRange,
    double? minPrice,
    double? maxPrice,
    RatingFilter? rating,
    ExperienceFilter? experience,
    List<CategoryEntity>? availableCategories,
    bool? isLoadingPriceRange,
  }) {
    return FilterState(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      priceRange: priceRange ?? this.priceRange,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      rating: rating ?? this.rating,
      experience: experience ?? this.experience,
      availableCategories: availableCategories ?? this.availableCategories,
      isLoadingPriceRange: isLoadingPriceRange ?? this.isLoadingPriceRange,
    );
  }
}
