import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import '../../../service/domain/entities/service_entity.dart';

abstract class BookmarkRepository {
  Future<Either<Failure, void>> bookmarkService(String serviceId);
  Future<Either<Failure, void>> unbookmarkService(String serviceId);
  Future<Either<Failure, List<ServiceEntity>>> getBookmarks({
    int page = 1,
    int limit = 20,
  });
}
