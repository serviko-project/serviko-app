import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import '../entities/earnings_summary_entity.dart';
import '../entities/transaction_entity.dart';

abstract class EarningsRepository {
  Future<Either<Failure, EarningsSummaryEntity>> getProviderEarningsSummary(
    String filter, {
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, void>> cashOut(double amount, String upiId);

  Future<Either<Failure, List<TransactionEntity>>> getTransactions(
    int page,
    int limit,
  );
}
