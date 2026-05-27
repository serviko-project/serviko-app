import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_active_promo_codes_usecase.dart';
import 'special_offers_state.dart';

class SpecialOffersCubit extends Cubit<SpecialOffersState> {
  final GetActivePromoCodesUseCase getActivePromoCodesUseCase;

  SpecialOffersCubit({required this.getActivePromoCodesUseCase})
    : super(SpecialOffersInitial());

  Future<void> fetchActiveOffers({int limit = 3}) async {
    emit(SpecialOffersLoading());

    final result = await getActivePromoCodesUseCase(
      GetActivePromoCodesParams(page: 1, limit: limit),
    );
    result.fold(
      (failure) => emit(SpecialOffersError(failure.message)),
      (promos) => emit(SpecialOffersLoaded(promoCodes: promos, currentPage: 0)),
    );
  }

  void updatePage(int index) {
    final currentState = state;
    if (currentState is SpecialOffersLoaded) {
      emit(currentState.copyWith(currentPage: index));
    }
  }
}
