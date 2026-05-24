import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/earnings_summary_entity.dart';
import '../repositories/earnings_repository.dart';

class GetEarningsSummaryUseCase
    extends UseCase<EarningsSummaryEntity, GetEarningsSummaryParams> {
  final EarningsRepository repository;

  GetEarningsSummaryUseCase({required this.repository});

  @override
  Future<Either<Failure, EarningsSummaryEntity>> call(
    GetEarningsSummaryParams params,
  ) async {
    return await repository.getProviderEarningsSummary(
      params.filter,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetEarningsSummaryParams extends Equatable {
  final String filter;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetEarningsSummaryParams({
    required this.filter,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [filter, startDate, endDate];
}
