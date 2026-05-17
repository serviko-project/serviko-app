import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';

enum CategoryDetailsStatus { initial, loading, success, error }

class CategoryDetailsState {
  final bool isSearching;
  final String searchQuery;
  final List<ServiceEntity> services;
  final CategoryDetailsStatus status;
  final String? errorMessage;

  const CategoryDetailsState({
    this.isSearching = false,
    this.searchQuery = '',
    this.services = const [],
    this.status = CategoryDetailsStatus.initial,
    this.errorMessage,
  });

  List<ServiceEntity> get filteredServices {
    if (searchQuery.isEmpty) return services;
    final query = searchQuery.toLowerCase();
    return services.where((service) {
      return service.categoryName.toLowerCase().contains(query) ||
          (service.providerName.toLowerCase().contains(query));
    }).toList();
  }

  CategoryDetailsState copyWith({
    bool? isSearching,
    String? searchQuery,
    List<ServiceEntity>? services,
    CategoryDetailsStatus? status,
    String? errorMessage,
  }) {
    return CategoryDetailsState(
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      services: services ?? this.services,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
