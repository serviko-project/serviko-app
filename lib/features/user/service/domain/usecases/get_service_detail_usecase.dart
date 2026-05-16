import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class GetServiceDetailUseCase
    implements UseCase<ServiceEntity, GetServiceDetailParams> {
  final ServiceRepository repository;

  GetServiceDetailUseCase(this.repository);

  @override
  Future<Either<Failure, ServiceEntity>> call(
    GetServiceDetailParams params,
  ) async {
    return await repository.getServiceDetail(params.id);
  }
}

class GetServiceDetailParams extends Equatable {
  final String id;

  const GetServiceDetailParams({required this.id});

  @override
  List<Object?> get props => [id];
}
