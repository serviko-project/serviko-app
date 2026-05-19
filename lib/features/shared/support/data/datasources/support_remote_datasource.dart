import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/features/shared/support/data/models/faq_model.dart';
import 'package:serviko_app/features/shared/support/data/models/privacy_policy_model.dart';

// Abstract Support Remote Data Source
abstract class SupportRemoteDataSource {
  Future<List<FaqModel>> getFAQs({String? category, String? search});

  Future<PrivacyPolicyModel> getPrivacyPolicy();
}

// Implementation of Support Remote Data Source
class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final ApiClient _apiClient;

  const SupportRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<FaqModel>> getFAQs({String? category, String? search}) {
    Map<String, String> params = {};
    if (category != null) {
      params['category'] = category;
    }
    if (search != null) {
      params['search'] = search;
    }
    return _apiClient.request<List<FaqModel>>(
      call: () =>
          _apiClient.dio.get('/api/v1/support/faqs', queryParameters: params),
      parser: (data) {
        final list = data as List<dynamic>;
        return list
            .map((json) => FaqModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<PrivacyPolicyModel> getPrivacyPolicy() {
    return _apiClient.request<PrivacyPolicyModel>(
      call: () => _apiClient.dio.get('/api/v1/support/privacy-policy'),
      parser: (data) {
        final itemData = data as Map<String, dynamic>;
        return PrivacyPolicyModel.fromJson(itemData);
      },
    );
  }
}
