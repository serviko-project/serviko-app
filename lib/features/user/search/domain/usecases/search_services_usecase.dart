import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';
import 'package:serviko_app/features/user/search/domain/repositories/search_repository.dart';

class SearchServicesUseCase
    implements UseCase<List<ServiceEntity>, SearchParams> {
  final SearchRepository repository;

  SearchServicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceEntity>>> call(SearchParams params) async {
    return await repository.searchServices(
      params.query,
      categoryId: params.categoryId,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      minRating: params.minRating,
      minExperience: params.minExperience,
      maxExperience: params.maxExperience,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchParams extends Equatable {
  final String query;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final int? minExperience;
  final int? maxExperience;
  final int page;
  final int limit;

  const SearchParams({
    required this.query,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.minExperience,
    this.maxExperience,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [
    query,
    categoryId,
    minPrice,
    maxPrice,
    minRating,
    minExperience,
    maxExperience,
    page,
    limit,
  ];
}
