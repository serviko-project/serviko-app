import 'package:dio/dio.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/network/api_client.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await apiClient.dio.get('/api/v1/categories/');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List<dynamic> categoriesList = data['data'];
          return categoriesList.map((json) {
            return CategoryModel.fromJson(json as Map<String, dynamic>);
          }).toList();
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to load categories');
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
