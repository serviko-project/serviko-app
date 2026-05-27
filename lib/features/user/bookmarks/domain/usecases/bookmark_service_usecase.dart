import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../repositories/bookmark_repository.dart';

class BookmarkServiceUseCase implements UseCase<void, BookmarkParams> {
  final BookmarkRepository repository;

  BookmarkServiceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(BookmarkParams params) async {
    return await repository.bookmarkService(params.serviceId);
  }
}

class BookmarkParams extends Equatable {
  final String serviceId;

  const BookmarkParams({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}
