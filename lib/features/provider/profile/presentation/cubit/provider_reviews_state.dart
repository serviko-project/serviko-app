import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/user/booking/domain/entities/review_entity.dart';

enum ProviderReviewsStatus { initial, loading, loaded, loadingMore, error }

class ProviderReviewsState extends Equatable {
  final ProviderReviewsStatus status;
  final List<ReviewEntity> reviews;
  final double averageRating;
  final int totalReviews;
  final int page;
  final bool hasMore;
  final String? message;

  const ProviderReviewsState({
    this.status = ProviderReviewsStatus.initial,
    this.reviews = const [],
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.page = 1,
    this.hasMore = true,
    this.message,
  });

  ProviderReviewsState copyWith({
    ProviderReviewsStatus? status,
    List<ReviewEntity>? reviews,
    double? averageRating,
    int? totalReviews,
    int? page,
    bool? hasMore,
    String? message,
  }) {
    return ProviderReviewsState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reviews,
    averageRating,
    totalReviews,
    page,
    hasMore,
    message,
  ];
}
