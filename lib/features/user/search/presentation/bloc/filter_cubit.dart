import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_state.dart';
import '../../domain/models/filter_enums.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../domain/usecases/get_price_range_usecase.dart';

class FilterCubit extends Cubit<FilterState> {
  final GetPriceRangeUseCase getPriceRangeUseCase;

  FilterCubit({required this.getPriceRangeUseCase})
    : super(
        const FilterState(
          categoryId: null,
          priceRange: RangeValues(0, 500),
          minPrice: 0.0,
          maxPrice: 500.0,
          rating: RatingFilter.all,
          experience: ExperienceFilter.any,
          availableCategories: [],
        ),
      ) {
    loadPriceRange(null);
  }

  Future<void> loadPriceRange(String? categoryId) async {
    emit(state.copyWith(isLoadingPriceRange: true));
    final result = await getPriceRangeUseCase(categoryId: categoryId);
    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingPriceRange: false));
      },
      (range) {
        final minPrice = range['min_price'] ?? 0.0;
        final maxPrice = range['max_price'] ?? 500.0;
        emit(
          state.copyWith(
            minPrice: minPrice,
            maxPrice: maxPrice,
            priceRange: RangeValues(minPrice, maxPrice),
            isLoadingPriceRange: false,
          ),
        );
      },
    );
  }

  void setCategoryId(String? categoryId) {
    emit(
      state.copyWith(categoryId: categoryId, clearCategory: categoryId == null),
    );
    loadPriceRange(categoryId);
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
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        priceRange: RangeValues(state.minPrice, state.maxPrice),
        rating: RatingFilter.all,
        experience: ExperienceFilter.any,
        availableCategories: state.availableCategories,
      ),
    );
    loadPriceRange(null);
  }
}
