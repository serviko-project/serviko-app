import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/search_services_usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/get_recent_searches_usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/save_recent_search_usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/remove_recent_search_usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/clear_recent_searches_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchServicesUseCase searchServicesUseCase;
  final GetRecentSearchesUseCase getRecentSearchesUseCase;
  final SaveRecentSearchUseCase saveRecentSearchUseCase;
  final RemoveRecentSearchUseCase removeRecentSearchUseCase;
  final ClearRecentSearchesUseCase clearRecentSearchesUseCase;

  SearchCubit({
    required this.searchServicesUseCase,
    required this.getRecentSearchesUseCase,
    required this.saveRecentSearchUseCase,
    required this.removeRecentSearchUseCase,
    required this.clearRecentSearchesUseCase,
  }) : super(SearchInitial([])) {
    loadRecentSearches();
  }

  final List<String> _recents = [];

  Future<void> loadRecentSearches() async {
    final result = await getRecentSearchesUseCase(const NoParams());
    result.fold((failure) => emit(SearchInitial(const [])), (recentsList) {
      _recents.clear();
      _recents.addAll(recentsList);
      emit(SearchInitial(List.from(_recents)));
    });
  }

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
      await loadRecentSearches();
      return;
    }

    emit(SearchLoading());

    if (trimmedQuery.isNotEmpty) {
      await saveRecentSearchUseCase(trimmedQuery);
      _recents.remove(trimmedQuery);
      _recents.insert(0, trimmedQuery);
      if (_recents.length > 10) {
        _recents.removeLast();
      }
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

  Future<void> clearRecents() async {
    await clearRecentSearchesUseCase(const NoParams());
    _recents.clear();
    if (state is SearchInitial) {
      emit(SearchInitial(const []));
    }
  }

  Future<void> removeRecent(String query) async {
    await removeRecentSearchUseCase(query);
    _recents.remove(query);
    if (state is SearchInitial) {
      emit(SearchInitial(List.from(_recents)));
    }
  }
}
