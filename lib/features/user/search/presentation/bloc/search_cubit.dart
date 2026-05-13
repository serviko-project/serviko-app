import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/search/domain/usecases/search_services_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchServicesUseCase searchServicesUseCase;

  SearchCubit({required this.searchServicesUseCase}) : super(SearchInitial([]));

  final List<String> _recents = [];

  Future<void> search(
    String query, {
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int? minExperience,
    int? maxExperience,
  }) async {
    final trimmedQuery = query.trim();

    // Check if any filter is applied
    final isDefaultPrice =
        (minPrice == null || minPrice == 0) &&
        (maxPrice == null || maxPrice == 500);
    final isDefaultRating = minRating == null;
    final isDefaultExperience = minExperience == null && maxExperience == null;

    final isInitialState =
        trimmedQuery.isEmpty &&
        categoryId == null &&
        isDefaultPrice &&
        isDefaultRating &&
        isDefaultExperience;

    if (isInitialState) {
      emit(SearchInitial(List.from(_recents)));
      return;
    }

    emit(SearchLoading());

    if (trimmedQuery.isNotEmpty && !_recents.contains(trimmedQuery)) {
      _recents.insert(0, trimmedQuery);
    }

    final result = await searchServicesUseCase(
      SearchParams(
        query: trimmedQuery,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        minExperience: minExperience,
        maxExperience: maxExperience,
      ),
    );

    result.fold((failure) => emit(SearchError(failure.message)), (services) {
      if (services.isEmpty) {
        emit(SearchEmpty(trimmedQuery));
      } else {
        emit(SearchLoaded(trimmedQuery, services.length, services));
      }
    });
  }

  void clearRecents() {
    _recents.clear();
    if (state is SearchInitial) {
      emit(SearchInitial(List.from(_recents)));
    }
  }

  void removeRecent(String query) {
    _recents.remove(query);
    if (state is SearchInitial) {
      emit(SearchInitial(List.from(_recents)));
    }
  }
}
