import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_reviews_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_reviews_stats_usecase.dart';
import 'provider_reviews_state.dart';

class ProviderReviewsCubit extends Cubit<ProviderReviewsState> {
  final GetProviderReviewsUseCase getProviderReviewsUseCase;
  final GetProviderReviewsStatsUseCase getProviderReviewsStatsUseCase;

  ProviderReviewsCubit({
    required this.getProviderReviewsUseCase,
    required this.getProviderReviewsStatsUseCase,
  }) : super(const ProviderReviewsState());

  // Fetch reviews, rating and total count stats
  Future<void> fetchReviewStats(String providerId) async {
    final result = await getProviderReviewsStatsUseCase(providerId);
    result.fold((failure) {}, (stats) {
      emit(
        state.copyWith(
          averageRating: (stats['average_rating'] as num?)?.toDouble() ?? 0.0,
          totalReviews: (stats['total_reviews'] as num?)?.toInt() ?? 0,
        ),
      );
    });
  }

  // Fetch reviews list
  Future<void> fetchReviews(String providerId, {bool refresh = false}) async {
    if (!refresh &&
        (!state.hasMore ||
            state.status == ProviderReviewsStatus.loading ||
            state.status == ProviderReviewsStatus.loadingMore)) {
      return;
    }

    final targetPage = refresh ? 1 : state.page;
    final isFirstPage = targetPage == 1;

    emit(
      state.copyWith(
        status: isFirstPage
            ? ProviderReviewsStatus.loading
            : ProviderReviewsStatus.loadingMore,
        reviews: isFirstPage ? [] : state.reviews,
        page: targetPage,
      ),
    );

    if (isFirstPage) {
      await fetchReviewStats(providerId);
    }

    final result = await getProviderReviewsUseCase(
      GetProviderReviewsParams(
        providerId: providerId,
        page: targetPage,
        limit: 10,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProviderReviewsStatus.error,
            message: failure.message,
          ),
        );
      },
      (newReviews) {
        final allReviews = isFirstPage
            ? newReviews
            : [...state.reviews, ...newReviews];
        final hasMore = newReviews.length >= 10;

        emit(
          state.copyWith(
            status: ProviderReviewsStatus.loaded,
            reviews: allReviews,
            page: targetPage + 1,
            hasMore: hasMore,
          ),
        );
      },
    );
  }
}
