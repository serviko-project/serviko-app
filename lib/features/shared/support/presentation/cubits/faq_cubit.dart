import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/shared/support/domain/usecases/get_faqs_usecase.dart';
import 'package:serviko_app/features/shared/support/presentation/cubits/faq_state.dart';

// Cubit to manage FAQ data and UI filter states
class FaqCubit extends Cubit<FaqState> {
  final GetFAQsUseCase _getFAQsUseCase;
  Timer? _searchDebounce;

  FaqCubit({required GetFAQsUseCase getFAQsUseCase})
    : _getFAQsUseCase = getFAQsUseCase,
      super(const FaqInitial());

  Future<void> loadFAQs() async {
    emit(
      FaqLoading(
        selectedCategory: state.selectedCategory,
        searchQuery: state.searchQuery,
        expandedFaqId: state.expandedFaqId,
      ),
    );

    await _fetchFAQs(
      category: state.selectedCategory,
      search: state.searchQuery,
    );
  }

  void selectCategory(String category) {
    if (state.selectedCategory == category) return;
    _searchDebounce?.cancel();

    emit(
      FaqLoading(
        selectedCategory: category,
        searchQuery: state.searchQuery,
        expandedFaqId: null,
      ),
    );

    _fetchFAQs(category: category, search: state.searchQuery);
  }

  void updateSearchQuery(String query) {
    if (state.searchQuery == query) return;
    _searchDebounce?.cancel();

    emit(
      state is FaqLoaded
          ? (state as FaqLoaded).copyWith(
              searchQuery: query,
              clearExpandedFaqId: true,
            )
          : FaqLoading(
              selectedCategory: state.selectedCategory,
              searchQuery: query,
              expandedFaqId: null,
            ),
    );

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      emit(
        FaqLoading(
          selectedCategory: state.selectedCategory,
          searchQuery: query,
          expandedFaqId: null,
        ),
      );
      _fetchFAQs(category: state.selectedCategory, search: query);
    });
  }

  void clearSearchQuery() {
    _searchDebounce?.cancel();
    emit(
      FaqLoading(
        selectedCategory: state.selectedCategory,
        searchQuery: '',
        expandedFaqId: null,
      ),
    );
    _fetchFAQs(category: state.selectedCategory, search: '');
  }

  void toggleFaq(String? faqId) {
    if (state is FaqLoaded) {
      final loadedState = state as FaqLoaded;
      final newExpandedId = loadedState.expandedFaqId == faqId ? null : faqId;
      emit(
        loadedState.copyWith(
          expandedFaqId: newExpandedId,
          clearExpandedFaqId: newExpandedId == null,
        ),
      );
    }
  }

  Future<void> _fetchFAQs({
    required String category,
    required String search,
  }) async {
    final result = await _getFAQsUseCase(
      GetFAQsParams(
        category: category == 'All' ? null : category,
        search: search.isEmpty ? null : search,
      ),
    );

    result.fold(
      (failure) => emit(
        FaqError(
          failure.message,
          selectedCategory: category,
          searchQuery: search,
          expandedFaqId: null,
        ),
      ),
      (faqs) => emit(
        FaqLoaded(
          faqs,
          selectedCategory: category,
          searchQuery: search,
          expandedFaqId: null,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
