import 'package:equatable/equatable.dart';
import '../../domain/entities/provider_dashboard_stats_entity.dart';

abstract class ProviderDashboardState extends Equatable {
  const ProviderDashboardState();

  @override
  List<Object?> get props => [];
}

class ProviderDashboardInitial extends ProviderDashboardState {
  const ProviderDashboardInitial();
}

class ProviderDashboardLoading extends ProviderDashboardState {
  const ProviderDashboardLoading();
}

class ProviderDashboardLoaded extends ProviderDashboardState {
  final ProviderDashboardStatsEntity stats;

  const ProviderDashboardLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];
}

class ProviderDashboardError extends ProviderDashboardState {
  final String message;

  const ProviderDashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
