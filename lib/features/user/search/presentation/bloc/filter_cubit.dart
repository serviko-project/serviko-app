import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_state.dart';
import '../../domain/models/filter_enums.dart';
import '../../../category/domain/entities/category_entity.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit()
    : super(
        const FilterState(
          categoryId: null,
          priceRange: RangeValues(0, 500),
          rating: RatingFilter.all,
          experience: ExperienceFilter.any,
          availableCategories: [],
        ),
      );

  void setCategoryId(String? categoryId) {
    emit(
      state.copyWith(categoryId: categoryId, clearCategory: categoryId == null),
    );
  }

  void setAvailableCategories(List<CategoryEntity> categories) {
    emit(state.copyWith(availableCategories: categories));
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
        categoryId: null,
        priceRange: const RangeValues(0, 500),
        rating: RatingFilter.all,
        experience: ExperienceFilter.any,
        availableCategories: state.availableCategories,
      ),
    );
  }
}
