import 'package:intl/intl.dart';
import '../../../../../core/network/api_client.dart';
import '../models/earnings_summary_model.dart';
import '../models/transaction_model.dart';

abstract class EarningsRemoteDataSource {
  Future<EarningsSummaryModel> getProviderEarningsSummary(
    String filter, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<void> cashOut(double amount, String upiId);
  Future<List<TransactionModel>> getTransactions(int page, int limit);
}

class EarningsRemoteDataSourceImpl implements EarningsRemoteDataSource {
  final ApiClient apiClient;

  EarningsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<EarningsSummaryModel> getProviderEarningsSummary(
    String filter, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{'filter': filter};
    final formatter = DateFormat('yyyy-MM-dd');

    if (startDate != null) {
      queryParams['start_date'] = formatter.format(startDate);
    }
    if (endDate != null) {
      queryParams['end_date'] = formatter.format(endDate);
    }

    return apiClient.request<EarningsSummaryModel>(
      call: () => apiClient.dio.get(
        '/api/v1/earnings/me',
        queryParameters: queryParams,
      ),
      parser: (data) =>
          EarningsSummaryModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<void> cashOut(double amount, String upiId) async {
    await apiClient.request(
      call: () => apiClient.dio.post(
        '/api/v1/earnings/cashout',
        data: {'amount': amount, 'upi_id': upiId},
      ),
      parser: (data) => data,
    );
  }

  @override
  Future<List<TransactionModel>> getTransactions(int page, int limit) async {
    return apiClient.request<List<TransactionModel>>(
      call: () => apiClient.dio.get(
        '/api/v1/earnings/transactions',
        queryParameters: {'page': page, 'limit': limit},
      ),
      parser: (data) {
        final List list = data as List;
        return list.map((e) => TransactionModel.fromJson(e)).toList();
      },
    );
  }
}
