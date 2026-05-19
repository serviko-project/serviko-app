import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/shared/support/domain/entities/faq_item.dart';

sealed class FaqState extends Equatable {
  final String selectedCategory;
  final String searchQuery;
  final String? expandedFaqId;

  const FaqState({
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.expandedFaqId,
  });

  @override
  List<Object?> get props => [selectedCategory, searchQuery, expandedFaqId];
}

class FaqInitial extends FaqState {
  const FaqInitial({
    super.selectedCategory,
    super.searchQuery,
    super.expandedFaqId,
  });
}

class FaqLoading extends FaqState {
  const FaqLoading({
    super.selectedCategory,
    super.searchQuery,
    super.expandedFaqId,
  });
}

class FaqLoaded extends FaqState {
  final List<FaqItem> faqs;

  const FaqLoaded(
    this.faqs, {
    super.selectedCategory,
    super.searchQuery,
    super.expandedFaqId,
  });

  @override
  List<Object?> get props => [
    faqs,
    selectedCategory,
    searchQuery,
    expandedFaqId,
  ];

  FaqLoaded copyWith({
    List<FaqItem>? faqs,
    String? selectedCategory,
    String? searchQuery,
    String? expandedFaqId,
    bool clearExpandedFaqId = false,
  }) {
    return FaqLoaded(
      faqs ?? this.faqs,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      expandedFaqId: clearExpandedFaqId
          ? null
          : (expandedFaqId ?? this.expandedFaqId),
    );
  }
}

class FaqError extends FaqState {
  final String message;

  const FaqError(
    this.message, {
    super.selectedCategory,
    super.searchQuery,
    super.expandedFaqId,
  });

  @override
  List<Object?> get props => [
    message,
    selectedCategory,
    searchQuery,
    expandedFaqId,
  ];
}
