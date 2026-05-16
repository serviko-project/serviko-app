import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {
  final List<String> recentSearches;
  SearchInitial(this.recentSearches);
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final String query;
  final int totalFound;
  final List<ServiceEntity> results;
  SearchLoaded(this.query, this.totalFound, this.results);
}

class SearchEmpty extends SearchState {
  final String query;
  SearchEmpty(this.query);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
