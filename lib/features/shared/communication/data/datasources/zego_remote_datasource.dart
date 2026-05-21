import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/features/shared/communication/data/models/provider_directory_model.dart';
import 'package:serviko_app/features/shared/communication/domain/models/token_response.dart';

abstract class ZegoRemoteDataSource {
  Future<TokenResponse> getToken();

  Future<List<ProviderDirectoryModel>> getProviderDirectory();
}

class ZegoRemoteDataSourceImpl implements ZegoRemoteDataSource {
  const ZegoRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<TokenResponse> getToken() {
    return _apiClient.request<TokenResponse>(
      call: () => _apiClient.dio.post('/api/v1/communication/token'),
      parser: (data) => TokenResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<List<ProviderDirectoryModel>> getProviderDirectory() {
    return _apiClient.request<List<ProviderDirectoryModel>>(
      call: () => _apiClient.dio.get('/api/v1/providers/directory'),
      parser: (data) {
        final list = data as List<dynamic>;
        return list.map((json) {
          return ProviderDirectoryModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      },
    );
  }
}
