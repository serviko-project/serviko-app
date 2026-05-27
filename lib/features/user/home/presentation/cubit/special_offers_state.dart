import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';

abstract class SpecialOffersState extends Equatable {
  const SpecialOffersState();

  @override
  List<Object?> get props => [];
}

class SpecialOffersInitial extends SpecialOffersState {}

class SpecialOffersLoading extends SpecialOffersState {}

class SpecialOffersLoaded extends SpecialOffersState {
  final List<PromoCode> promoCodes;
  final int currentPage;

  const SpecialOffersLoaded({
    required this.promoCodes,
    required this.currentPage,
  });

  SpecialOffersLoaded copyWith({
    List<PromoCode>? promoCodes,
    int? currentPage,
  }) {
    return SpecialOffersLoaded(
      promoCodes: promoCodes ?? this.promoCodes,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [promoCodes, currentPage];
}

class SpecialOffersError extends SpecialOffersState {
  final String message;

  const SpecialOffersError(this.message);

  @override
  List<Object?> get props => [message];
}
