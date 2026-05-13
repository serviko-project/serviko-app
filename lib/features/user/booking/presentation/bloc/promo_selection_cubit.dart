import 'package:flutter_bloc/flutter_bloc.dart';
import 'promo_selection_state.dart';

class PromoSelectionCubit extends Cubit<PromoSelectionState> {
  PromoSelectionCubit() : super(const PromoSelectionState());

  void selectPromo(String promoId) {
    emit(state.copyWith(selectedPromoId: promoId));
  }
}
