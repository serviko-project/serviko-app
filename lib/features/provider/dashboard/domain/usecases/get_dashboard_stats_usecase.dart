import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/provider_dashboard_stats_entity.dart';
import '../repositories/provider_dashboard_repository.dart';

class GetDashboardStatsUseCase
    extends UseCase<ProviderDashboardStatsEntity, NoParams> {
  final ProviderDashboardRepository repository;

  GetDashboardStatsUseCase({required this.repository});

  @override
  Future<Either<Failure, ProviderDashboardStatsEntity>> call(
    NoParams params,
  ) async {
    return await repository.getDashboardStats();
  }
}
