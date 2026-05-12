import 'package:dio/dio.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/features/user/service/data/models/service_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<ServiceModel>> searchServices(
    String query, {
    String? categoryId,
    int page = 1,
    int limit = 20,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ServiceModel>> searchServices(
    String query, {
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
      'search_query': query.trim(),
    };

    if (categoryId != null && categoryId.trim().isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }

    try {
      await apiClient.setFirebaseAuthToken();
      final response = await apiClient.dio.get(
        '/api/v1/services',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final dynamic dataField = data['data'];
          List<dynamic> servicesList;

          if (dataField is List) {
            servicesList = dataField;
          } else if (dataField is Map && dataField.containsKey('items')) {
            servicesList = dataField['items'] as List<dynamic>;
          } else {
            servicesList = [];
          }
          return servicesList.map((json) {
            return ServiceModel.fromJson(json as Map<String, dynamic>);
          }).toList();
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to load search results');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
