import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/search/domain/usecases/search_services_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchServicesUseCase searchServicesUseCase;

  SearchCubit({required this.searchServicesUseCase}) : super(SearchInitial([]));

  final List<String> _recents = [];

  Future<void> search(String query, {String? categoryId}) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty && categoryId == null) {
      emit(SearchInitial(List.from(_recents)));
      return;
    }

    emit(SearchLoading());

    if (trimmedQuery.isNotEmpty && !_recents.contains(trimmedQuery)) {
      _recents.insert(0, trimmedQuery);
    }

    final result = await searchServicesUseCase(
      SearchParams(query: trimmedQuery, categoryId: categoryId),
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
