import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../repositories/bookmark_repository.dart';

class UnbookmarkServiceUseCase implements UseCase<void, UnbookmarkParams> {
  final BookmarkRepository repository;

  UnbookmarkServiceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UnbookmarkParams params) async {
    return await repository.unbookmarkService(params.serviceId);
  }
}

class UnbookmarkParams extends Equatable {
  final String serviceId;

  const UnbookmarkParams({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}
