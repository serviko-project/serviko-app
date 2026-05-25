import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/get_transactions_usecase.dart';

// States
abstract class TransactionsState {}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final List<TransactionEntity> transactions;
  final bool hasReachedMax;

  TransactionsLoaded(this.transactions, this.hasReachedMax);
}

class TransactionsError extends TransactionsState {
  final String message;
  TransactionsError(this.message);
}

// Cubit
class TransactionsCubit extends Cubit<TransactionsState> {
  final GetTransactionsUseCase _getTransactionsUseCase;
  int _currentPage = 1;
  final int _limit = 20;
  bool _isFetching = false;

  TransactionsCubit(this._getTransactionsUseCase)
    : super(TransactionsInitial());

  Future<void> fetchTransactions({bool refresh = false}) async {
    if (_isFetching) return;

    if (refresh) {
      _currentPage = 1;
      emit(TransactionsLoading());
    } else {
      if (state is TransactionsLoaded &&
          (state as TransactionsLoaded).hasReachedMax) {
        return;
      }
    }

    _isFetching = true;
    final result = await _getTransactionsUseCase(_currentPage, _limit);
    _isFetching = false;

    result.fold((failure) => emit(TransactionsError(failure.message)), (
      newTransactions,
    ) {
      final bool isLastPage = newTransactions.length < _limit;

      if (state is TransactionsLoaded && !refresh) {
        final currentState = state as TransactionsLoaded;
        final updatedTransactions = List<TransactionEntity>.from(
          currentState.transactions,
        )..addAll(newTransactions);
        emit(TransactionsLoaded(updatedTransactions, isLastPage));
      } else {
        emit(TransactionsLoaded(newTransactions, isLastPage));
      }

      if (newTransactions.isNotEmpty) {
        _currentPage++;
      }
    });
  }
}
