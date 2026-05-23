import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/user/booking/domain/entities/review_entity.dart';

enum ServiceReviewsStatus { initial, loading, loaded, loadingMore, error }

class ServiceReviewsState extends Equatable {
  final ServiceReviewsStatus status;
  final List<ReviewEntity> reviews;
  final int? selectedRating;
  final int page;
  final bool hasMore;
  final String? message;

  const ServiceReviewsState({
    this.status = ServiceReviewsStatus.initial,
    this.reviews = const [],
    this.selectedRating,
    this.page = 1,
    this.hasMore = true,
    this.message,
  });

  ServiceReviewsState copyWith({
    ServiceReviewsStatus? status,
    List<ReviewEntity>? reviews,
    int? Function()? selectedRating,
    int? page,
    bool? hasMore,
    String? message,
  }) {
    return ServiceReviewsState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      selectedRating: selectedRating != null
          ? selectedRating()
          : this.selectedRating,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reviews,
    selectedRating,
    page,
    hasMore,
    message,
  ];
}
