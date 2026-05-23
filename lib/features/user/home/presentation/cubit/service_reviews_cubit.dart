import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_reviews_usecase.dart';
import 'service_reviews_state.dart';

class ServiceReviewsCubit extends Cubit<ServiceReviewsState> {
  final GetProviderReviewsUseCase getProviderReviewsUseCase;

  ServiceReviewsCubit({required this.getProviderReviewsUseCase})
    : super(const ServiceReviewsState());

  Future<void> fetchReviews(String providerId, {bool refresh = false}) async {
    if (!refresh &&
        (!state.hasMore ||
            state.status == ServiceReviewsStatus.loading ||
            state.status == ServiceReviewsStatus.loadingMore)) {
      return;
    }

    final targetPage = refresh ? 1 : state.page;
    final isFirstPage = targetPage == 1;

    emit(
      state.copyWith(
        status: isFirstPage
            ? ServiceReviewsStatus.loading
            : ServiceReviewsStatus.loadingMore,
        reviews: isFirstPage ? [] : state.reviews,
        page: targetPage,
      ),
    );

    final result = await getProviderReviewsUseCase(
      GetProviderReviewsParams(
        providerId: providerId,
        rating: state.selectedRating,
        page: targetPage,
        limit: 10,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ServiceReviewsStatus.error,
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
            status: ServiceReviewsStatus.loaded,
            reviews: allReviews,
            page: targetPage + 1,
            hasMore: hasMore,
          ),
        );
      },
    );
  }

  void selectRating(String providerId, int? rating) {
    if (state.selectedRating == rating &&
        state.status != ServiceReviewsStatus.initial) {
      return;
    }
    emit(state.copyWith(selectedRating: () => rating));
    fetchReviews(providerId, refresh: true);
  }
}
