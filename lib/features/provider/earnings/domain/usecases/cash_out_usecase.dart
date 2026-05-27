import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../repositories/earnings_repository.dart';

class CashOutUseCase extends UseCase<void, CashOutParams> {
  final EarningsRepository repository;

  CashOutUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CashOutParams params) {
    return repository.cashOut(params.amount, params.upiId);
  }
}

class CashOutParams extends Equatable {
  final double amount;
  final String upiId;

  const CashOutParams({required this.amount, required this.upiId});

  @override
  List<Object?> get props => [amount, upiId];
}
