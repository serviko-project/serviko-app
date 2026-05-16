import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/features/user/service/data/models/service_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<ServiceModel>> searchServices(
    String query, {
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int? minExperience,
    int? maxExperience,
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
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int? minExperience,
    int? maxExperience,
    int page = 1,
    int limit = 20,
  }) {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
      'search_query': query.trim(),
    };

    if (categoryId != null && categoryId.trim().isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }

    if (minPrice != null) queryParams['min_price'] = minPrice;
    if (maxPrice != null) queryParams['max_price'] = maxPrice;
    if (minRating != null) queryParams['min_rating'] = minRating;
    if (minExperience != null) queryParams['min_experience'] = minExperience;
    if (maxExperience != null) queryParams['max_experience'] = maxExperience;

    return apiClient.request(
      call: () =>
          apiClient.dio.get('/api/v1/services', queryParameters: queryParams),
      parser: (dataField) {
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
      },
    );
  }
}
