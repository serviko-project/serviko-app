import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_state.dart';
import '../../domain/models/filter_enums.dart';

class FilterCubit extends Cubit<FilterState> {
  static const List<String> _categories = [
    'All',
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
  ];

  FilterCubit()
    : super(
        const FilterState(
          category: 'All',
          priceRange: RangeValues(0, 500),
          rating: RatingFilter.all,
          experience: ExperienceFilter.any,
          availableCategories: _categories,
        ),
      );

  void setCategory(String category) {
    emit(state.copyWith(category: category));
  }

  void setPriceRange(RangeValues priceRange) {
    emit(state.copyWith(priceRange: priceRange));
  }

  void setRating(RatingFilter rating) {
    emit(state.copyWith(rating: rating));
  }

  void setExperience(ExperienceFilter experience) {
    emit(state.copyWith(experience: experience));
  }

  void reset() {
    emit(
      FilterState(
        category: 'All',
        priceRange: const RangeValues(0, 500),
        rating: RatingFilter.all,
        experience: ExperienceFilter.any,
        availableCategories: state.availableCategories,
      ),
    );
  }
}
