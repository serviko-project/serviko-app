import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/user/search/domain/repositories/search_repository.dart';

class GetPriceRangeUseCase {
  final SearchRepository repository;

  GetPriceRangeUseCase(this.repository);

  Future<Either<Failure, Map<String, double>>> call({String? categoryId}) {
    return repository.getPriceRange(categoryId: categoryId);
  }
}
