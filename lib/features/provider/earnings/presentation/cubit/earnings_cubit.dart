import 'package:flutter_bloc/flutter_bloc.dart';
import 'earnings_state.dart';
import '../../domain/usecases/get_earnings_summary_usecase.dart';

class EarningsCubit extends Cubit<EarningsState> {
  final GetEarningsSummaryUseCase _getEarningsSummaryUseCase;

  EarningsCubit({required GetEarningsSummaryUseCase getEarningsSummaryUseCase})
    : _getEarningsSummaryUseCase = getEarningsSummaryUseCase,
      super(EarningsInitial());

  Future<void> loadEarnings(
    String filter, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final currentState = state;
    if (currentState is EarningsLoaded) {
      emit(
        EarningsLoaded(
          selectedFilter: filter,
          summary: currentState.summary,
          recentTransactions: currentState.recentTransactions,
          isGraphLoading: true,
          startDate: startDate ?? currentState.startDate,
          endDate: endDate ?? currentState.endDate,
        ),
      );
    } else {
      emit(EarningsLoading());
    }

    final result = await _getEarningsSummaryUseCase(
      GetEarningsSummaryParams(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
      ),
    );

    result.fold(
      (failure) => emit(EarningsError(failure.message)),
      (summary) => emit(
        EarningsLoaded(
          selectedFilter: filter,
          summary: summary,
          recentTransactions: summary.recentTransactions,
          isGraphLoading: false,
          startDate:
              startDate ??
              (currentState is EarningsLoaded ? currentState.startDate : null),
          endDate:
              endDate ??
              (currentState is EarningsLoaded ? currentState.endDate : null),
        ),
      ),
    );
  }
}
