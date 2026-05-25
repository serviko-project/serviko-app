import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import 'provider_dashboard_state.dart';

class ProviderDashboardCubit extends Cubit<ProviderDashboardState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  ProviderDashboardCubit({required this.getDashboardStatsUseCase})
    : super(const ProviderDashboardInitial());

  // Fetch dashboard statistics
  Future<void> fetchDashboardStats() async {
    emit(const ProviderDashboardLoading());
    final result = await getDashboardStatsUseCase(const NoParams());
    result.fold(
      (failure) => emit(ProviderDashboardError(message: failure.message)),
      (stats) => emit(ProviderDashboardLoaded(stats: stats)),
    );
  }
}
