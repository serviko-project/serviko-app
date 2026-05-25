import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import '../entities/provider_dashboard_stats_entity.dart';

abstract class ProviderDashboardRepository {
  Future<Either<Failure, ProviderDashboardStatsEntity>> getDashboardStats();
}
