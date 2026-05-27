import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/search/domain/repositories/search_repository.dart';

class ClearRecentSearchesUseCase implements UseCase<void, NoParams> {
  final SearchRepository repository;

  ClearRecentSearchesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearRecentSearches();
  }
}
