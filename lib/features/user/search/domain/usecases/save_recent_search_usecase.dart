import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/search/domain/repositories/search_repository.dart';

class SaveRecentSearchUseCase implements UseCase<void, String> {
  final SearchRepository repository;

  SaveRecentSearchUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String query) async {
    return await repository.saveRecentSearch(query);
  }
}
