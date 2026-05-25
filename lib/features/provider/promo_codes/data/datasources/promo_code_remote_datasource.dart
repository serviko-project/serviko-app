import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/features/provider/promo_codes/data/models/promo_code_model.dart';

abstract class PromoCodeRemoteDataSource {
  Future<List<PromoCodeModel>> getPromoCodes({int page = 1, int limit = 20});

  Future<PromoCodeModel> createPromoCode(Map<String, dynamic> data);

  Future<PromoCodeModel> updatePromoCode(
    String promoId,
    Map<String, dynamic> data,
  );

  Future<PromoCodeModel> deactivatePromoCode(String promoId);
}

class PromoCodeRemoteDataSourceImpl implements PromoCodeRemoteDataSource {
  final ApiClient _apiClient;

  const PromoCodeRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<PromoCodeModel>> getPromoCodes({int page = 1, int limit = 20}) {
    return _apiClient.request<List<PromoCodeModel>>(
      call: () => _apiClient.dio.get(
        '/api/v1/promo-codes',
        queryParameters: {'page': page, 'limit': limit},
      ),
      parser: (data) {
        final list = data as List<dynamic>;
        return list.map((json) {
          return PromoCodeModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  @override
  Future<PromoCodeModel> createPromoCode(Map<String, dynamic> data) {
    return _apiClient.request<PromoCodeModel>(
      call: () => _apiClient.dio.post('/api/v1/promo-codes', data: data),
      parser: (data) {
        return PromoCodeModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<PromoCodeModel> updatePromoCode(
    String promoId,
    Map<String, dynamic> data,
  ) {
    return _apiClient.request<PromoCodeModel>(
      call: () =>
          _apiClient.dio.patch('/api/v1/promo-codes/$promoId', data: data),
      parser: (data) {
        return PromoCodeModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<PromoCodeModel> deactivatePromoCode(String promoId) {
    return _apiClient.request<PromoCodeModel>(
      call: () => _apiClient.dio.delete('/api/v1/promo-codes/$promoId'),
      parser: (data) {
        return PromoCodeModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }
}
