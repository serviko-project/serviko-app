import '../../../../../core/network/api_client.dart';
import '../models/provider_dashboard_stats_model.dart';

abstract class ProviderDashboardRemoteDataSource {
  Future<ProviderDashboardStatsModel> getDashboardStats();
}

class ProviderDashboardRemoteDataSourceImpl
    implements ProviderDashboardRemoteDataSource {
  final ApiClient apiClient;

  ProviderDashboardRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProviderDashboardStatsModel> getDashboardStats() async {
    return apiClient.request<ProviderDashboardStatsModel>(
      call: () => apiClient.dio.get('/api/v1/providers/dashboard'),
      parser: (data) =>
          ProviderDashboardStatsModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
