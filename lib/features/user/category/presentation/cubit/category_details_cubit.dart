import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/search/domain/usecases/search_services_usecase.dart';
import 'category_details_state.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsState> {
  final SearchServicesUseCase searchServicesUseCase;
  final String categoryId;

  CategoryDetailsCubit({
    required this.searchServicesUseCase,
    required this.categoryId,
  }) : super(const CategoryDetailsState());

  Timer? _debounce;

  Future<void> loadCategoryServices() async {
    emit(state.copyWith(status: CategoryDetailsStatus.loading));

    final result = await searchServicesUseCase(
      SearchParams(query: '', categoryId: categoryId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryDetailsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (services) => emit(
        state.copyWith(
          status: CategoryDetailsStatus.success,
          services: services,
        ),
      ),
    );
  }

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

    // Trigger loading status during debounce
    emit(state.copyWith(status: CategoryDetailsStatus.loading));

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: CategoryDetailsStatus.success,
            searchQuery: value.trim(),
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
