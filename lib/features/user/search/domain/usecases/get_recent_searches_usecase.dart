import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/search/domain/repositories/search_repository.dart';

class GetRecentSearchesUseCase implements UseCase<List<String>, NoParams> {
  final SearchRepository repository;

  GetRecentSearchesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getRecentSearches();
  }
}
