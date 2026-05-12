import 'package:dio/dio.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/network/api_client.dart';
import '../models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getPopularServices({String? categoryId});
  Future<ServiceModel> getServiceDetail(String id);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final ApiClient apiClient;

  ServiceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ServiceModel>> getPopularServices({String? categoryId}) async {
    final Map<String, dynamic> queryParams = {};
    if (categoryId != null && categoryId.trim().isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }

    try {
      await apiClient.setFirebaseAuthToken();
      final response = await apiClient.dio.get(
        '/api/v1/services/popular',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List<dynamic> servicesList = data['data'];
          return servicesList
              .map(
                (json) => ServiceModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to load popular services');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ServiceModel> getServiceDetail(String id) async {
    try {
      await apiClient.setFirebaseAuthToken();
      final response = await apiClient.dio.get('/api/v1/services/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return ServiceModel.fromJson(data['data'] as Map<String, dynamic>);
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to load service detail');
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
