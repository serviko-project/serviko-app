import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../../../service/domain/entities/service_entity.dart';
import '../repositories/bookmark_repository.dart';

class GetBookmarksUseCase
    implements UseCase<List<ServiceEntity>, GetBookmarksParams> {
  final BookmarkRepository repository;

  GetBookmarksUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceEntity>>> call(
    GetBookmarksParams params,
  ) async {
    return await repository.getBookmarks(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetBookmarksParams extends Equatable {
  final int page;
  final int limit;

  const GetBookmarksParams({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}
