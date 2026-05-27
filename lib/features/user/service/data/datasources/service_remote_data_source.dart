import 'package:serviko_app/core/network/api_client.dart';
import '../models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getPopularServices({
    String? categoryId,
    int? limit,
  });
  Future<ServiceModel> getServiceDetail(String id);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final ApiClient apiClient;

  ServiceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ServiceModel>> getPopularServices({
    String? categoryId,
    int? limit,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (categoryId != null && categoryId.trim().isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }
    if (limit != null) {
      queryParams['limit'] = limit;
    }

    return apiClient.request<List<ServiceModel>>(
      call: () => apiClient.dio.get(
        '/api/v1/services/popular',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      ),
      parser: (data) {
        final List<dynamic> servicesList = data;
        return servicesList.map((json) {
          return ServiceModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  @override
  Future<ServiceModel> getServiceDetail(String id) async {
    return apiClient.request<ServiceModel>(
      call: () => apiClient.dio.get('/api/v1/services/$id'),
      parser: (data) => ServiceModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
