import '../../domain/entities/earnings_summary_entity.dart';
import 'transaction_model.dart';

class EarningsSummaryModel extends EarningsSummaryEntity {
  EarningsSummaryModel({
    required super.availableBalance,
    required super.periodLabel,
    required super.periodEarnings,
    required super.filter,
    required super.graphData,
    required super.recentTransactions,
  });

  factory EarningsSummaryModel.fromJson(Map<String, dynamic> json) {
    return EarningsSummaryModel(
      availableBalance: (json['available_balance'] ?? 0).toDouble(),
      periodLabel: json['period_label'] ?? '',
      periodEarnings: (json['period_earnings'] ?? 0).toDouble(),
      filter: json['filter'] ?? 'Weekly',
      graphData:
          (json['graph_data'] as List<dynamic>?)?.map((e) {
            return GraphDataPointModel.fromJson(e as Map<String, dynamic>);
          }).toList() ??
          [],
      recentTransactions:
          (json['recent_transactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class GraphDataPointModel extends GraphDataPointEntity {
  GraphDataPointModel({required super.label, required super.value});

  factory GraphDataPointModel.fromJson(Map<String, dynamic> json) {
    return GraphDataPointModel(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
    );
  }
}
