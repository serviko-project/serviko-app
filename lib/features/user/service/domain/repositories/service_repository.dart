import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import '../entities/service_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<ServiceEntity>>> getPopularServices({
    String? categoryId,
  });
  Future<Either<Failure, ServiceEntity>> getServiceDetail(String id);
}
