import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';

import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class GetPopularServicesUseCase
    implements UseCase<List<ServiceEntity>, GetPopularServicesParams> {
  final ServiceRepository repository;

  GetPopularServicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceEntity>>> call(
    GetPopularServicesParams params,
  ) async {
    return await repository.getPopularServices(categoryId: params.categoryId);
  }
}

class GetPopularServicesParams extends Equatable {
  final String? categoryId;

  const GetPopularServicesParams({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
