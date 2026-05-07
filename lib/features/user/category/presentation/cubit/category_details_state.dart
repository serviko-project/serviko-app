class CategoryDetailsState {
  final bool isSearching;
  final String searchQuery;
  final int totalServices;

  const CategoryDetailsState({
    this.isSearching = false,
    this.searchQuery = '',
    this.totalServices = 10,
  });

  // Filtered count based on search query
  int get filteredCount {
    if (searchQuery.isEmpty) return totalServices;
    return List.generate(totalServices, (i) => i).where((i) {
      final title = 'Service ${i + 1}'.toLowerCase();
      final provider = 'Provider ${i + 1}'.toLowerCase();
      final query = searchQuery.toLowerCase();
      return title.contains(query) || provider.contains(query);
    }).length;
  }

  // Filtered indices
  List<int> get filteredIndices {
    if (searchQuery.isEmpty) {
      return List.generate(totalServices, (i) => i);
    }
    return List.generate(totalServices, (i) => i).where((i) {
      final title = 'Service ${i + 1}'.toLowerCase();
      final provider = 'Provider ${i + 1}'.toLowerCase();
      final query = searchQuery.toLowerCase();
      return title.contains(query) || provider.contains(query);
    }).toList();
  }

  CategoryDetailsState copyWith({
    bool? isSearching,
    String? searchQuery,
    int? totalServices,
  }) {
    return CategoryDetailsState(
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      totalServices: totalServices ?? this.totalServices,
    );
  }
}
