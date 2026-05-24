import 'transaction_entity.dart';

class EarningsSummaryEntity {
  final double availableBalance;
  final String periodLabel;
  final double periodEarnings;
  final String filter;
  final List<GraphDataPointEntity> graphData;
  final List<TransactionEntity> recentTransactions;

  EarningsSummaryEntity({
    required this.availableBalance,
    required this.periodLabel,
    required this.periodEarnings,
    required this.filter,
    required this.graphData,
    required this.recentTransactions,
  });
}

class GraphDataPointEntity {
  final String label;
  final double value;

  GraphDataPointEntity({required this.label, required this.value});
}
