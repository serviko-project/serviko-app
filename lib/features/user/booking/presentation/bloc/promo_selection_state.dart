import 'package:equatable/equatable.dart';

class PromoSelectionState extends Equatable {
  final String? selectedPromoId;

  const PromoSelectionState({this.selectedPromoId});

  PromoSelectionState copyWith({String? selectedPromoId}) {
    return PromoSelectionState(
      selectedPromoId: selectedPromoId ?? this.selectedPromoId,
    );
  }

  @override
  List<Object?> get props => [selectedPromoId];
}
