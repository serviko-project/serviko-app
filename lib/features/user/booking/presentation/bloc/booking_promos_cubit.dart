import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_promos_usecase.dart';
import 'booking_promos_state.dart';

class BookingPromosCubit extends Cubit<BookingPromosState> {
  final GetProviderPromosUseCase _getProviderPromosUseCase;

  BookingPromosCubit({
    required GetProviderPromosUseCase getProviderPromosUseCase,
  }) : _getProviderPromosUseCase = getProviderPromosUseCase,
       super(const BookingPromosState());

  Future<void> loadPromos(String providerId) async {
    emit(state.copyWith(status: BookingPromosStatus.loading));

    final result = await _getProviderPromosUseCase(
      GetProviderPromosParams(providerId: providerId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingPromosStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (promos) {
        final now = DateTime.now();
        final activePromos = promos.where((p) {
          if (!p.isActive) return false;
          if (p.expiresAt != null && p.expiresAt!.isBefore(now)) return false;
          if (p.maxUses != null && p.usageCount >= p.maxUses!) return false;
          return true;
        }).toList();
        emit(
          state.copyWith(
            status: BookingPromosStatus.success,
            promos: activePromos,
          ),
        );
      },
    );
  }
}
