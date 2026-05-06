import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_details_state.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsState> {
  CategoryDetailsCubit() : super(const CategoryDetailsState());

  Timer? _debounce;

  void toggleSearch() {
    if (state.isSearching) {
      _debounce?.cancel();
      emit(state.copyWith(isSearching: false, searchQuery: ''));
    } else {
      emit(state.copyWith(isSearching: true));
    }
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!isClosed) {
        emit(state.copyWith(searchQuery: value));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
