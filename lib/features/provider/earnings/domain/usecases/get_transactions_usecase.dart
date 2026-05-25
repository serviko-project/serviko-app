import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/earnings_repository.dart';

class GetTransactionsUseCase {
  final EarningsRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call(
    int page,
    int limit,
  ) async {
    return repository.getTransactions(page, limit);
  }
}
