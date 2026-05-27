import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/cash_out_usecase.dart';

// States
abstract class CashOutState extends Equatable {
  const CashOutState();

  @override
  List<Object> get props => [];
}

class CashOutInitial extends CashOutState {}

class CashOutLoading extends CashOutState {}

class CashOutSuccess extends CashOutState {}

class CashOutError extends CashOutState {
  final String message;

  const CashOutError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class CashOutCubit extends Cubit<CashOutState> {
  final CashOutUseCase _cashOutUseCase;

  CashOutCubit({required CashOutUseCase cashOutUseCase})
    : _cashOutUseCase = cashOutUseCase,
      super(CashOutInitial());

  Future<void> cashOut(double amount, String upiId) async {
    emit(CashOutLoading());

    final result = await _cashOutUseCase(
      CashOutParams(amount: amount, upiId: upiId),
    );
    result.fold(
      (failure) => emit(CashOutError(failure.message)),
      (_) => emit(CashOutSuccess()),
    );
  }
}
