import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<ServiceEntity>>> searchServices(
    String query, {
    String? categoryId,
    int page = 1,
    int limit = 20,
  });
}
