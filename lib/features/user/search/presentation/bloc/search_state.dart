abstract class SearchState {}

class SearchInitial extends SearchState {
  final List<String> recentSearches;
  SearchInitial(this.recentSearches);
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final String query;
  final int totalFound;
  final List<Map<String, dynamic>> results;
  SearchLoaded(this.query, this.totalFound, this.results);
}

class SearchEmpty extends SearchState {
  final String query;
  SearchEmpty(this.query);
}
