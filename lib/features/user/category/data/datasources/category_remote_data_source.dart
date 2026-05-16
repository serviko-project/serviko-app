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
    return apiClient.request<List<CategoryModel>>(
      requiresAuth: false,
      call: () => apiClient.dio.get('/api/v1/categories/'),
      parser: (data) {
        final List<dynamic> categoriesList = data;
        return categoriesList.map((json) {
          return CategoryModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      },
    );
  }
}
