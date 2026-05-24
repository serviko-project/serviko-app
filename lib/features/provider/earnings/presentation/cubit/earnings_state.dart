import 'package:equatable/equatable.dart';
import '../../domain/entities/earnings_summary_entity.dart';
import '../../domain/entities/transaction_entity.dart';

abstract class EarningsState extends Equatable {
  const EarningsState();

  @override
  List<Object?> get props => [];
}

class EarningsInitial extends EarningsState {}

class EarningsLoading extends EarningsState {}

class EarningsLoaded extends EarningsState {
  final String selectedFilter;
  final EarningsSummaryEntity summary;
  final List<TransactionEntity> recentTransactions;
  final bool isGraphLoading;
  final DateTime? startDate;
  final DateTime? endDate;

  const EarningsLoaded({
    required this.selectedFilter,
    required this.summary,
    required this.recentTransactions,
    this.isGraphLoading = false,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    selectedFilter,
    summary,
    recentTransactions,
    isGraphLoading,
    startDate,
    endDate,
  ];
}

class EarningsError extends EarningsState {
  final String message;

  const EarningsError(this.message);

  @override
  List<Object?> get props => [message];
}
