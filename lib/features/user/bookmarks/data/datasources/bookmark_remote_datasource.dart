import 'package:serviko_app/core/network/api_client.dart';
import '../../../service/data/models/service_model.dart';

abstract class BookmarkRemoteDataSource {
  Future<void> bookmarkService(String serviceId);
  Future<void> unbookmarkService(String serviceId);
  Future<List<ServiceModel>> getBookmarks({int page = 1, int limit = 20});
}

class BookmarkRemoteDataSourceImpl implements BookmarkRemoteDataSource {
  final ApiClient apiClient;

  BookmarkRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> bookmarkService(String serviceId) async {
    return apiClient.request<void>(
      call: () => apiClient.dio.post(
        '/api/v1/bookmarks',
        data: {'service_id': serviceId},
      ),
      parser: (_) {},
    );
  }

  @override
  Future<void> unbookmarkService(String serviceId) async {
    return apiClient.request<void>(
      call: () => apiClient.dio.delete('/api/v1/bookmarks/$serviceId'),
      parser: (_) {},
    );
  }

  @override
  Future<List<ServiceModel>> getBookmarks({
    int page = 1,
    int limit = 20,
  }) async {
    return apiClient.request<List<ServiceModel>>(
      call: () => apiClient.dio.get(
        '/api/v1/bookmarks',
        queryParameters: {'page': page, 'limit': limit},
      ),
      parser: (data) {
        final List<dynamic> list = data;
        return list.map((json) {
          return ServiceModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      },
    );
  }
}
