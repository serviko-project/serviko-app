import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/create_promo_code_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/deactivate_promo_code_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/get_promo_codes_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/update_promo_code_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'provider_promo_state.dart';

class ProviderPromoCubit extends Cubit<ProviderPromoState> {
  final GetPromoCodesUseCase _getPromoCodes;
  final CreatePromoCodeUseCase _createPromoCode;
  final UpdatePromoCodeUseCase _updatePromoCode;
  final DeactivatePromoCodeUseCase _deactivatePromoCode;

  ProviderPromoCubit({
    required GetPromoCodesUseCase getPromoCodes,
    required CreatePromoCodeUseCase createPromoCode,
    required UpdatePromoCodeUseCase updatePromoCode,
    required DeactivatePromoCodeUseCase deactivatePromoCode,
  }) : _getPromoCodes = getPromoCodes,
       _createPromoCode = createPromoCode,
       _updatePromoCode = updatePromoCode,
       _deactivatePromoCode = deactivatePromoCode,
       super(const ProviderPromoState());

  Future<void> loadPromoCodes() async {
    emit(state.copyWith(status: ProviderPromoStatus.loading));

    final result = await _getPromoCodes(const GetPromoCodesParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderPromoStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (promos) => emit(
        state.copyWith(status: ProviderPromoStatus.success, promoCodes: promos),
      ),
    );
  }

  Future<void> createPromo({
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    double? minBookingAmount,
    int? maxUses,
    double? maxDiscountAmount,
    DateTime? expiresAt,
  }) async {
    emit(state.copyWith(status: ProviderPromoStatus.submitting));
    final data = {
      'code': code,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_booking_amount': minBookingAmount,
      'max_uses': maxUses,
      'max_discount_amount': maxDiscountAmount,
      'expires_at': expiresAt?.toUtc().toIso8601String(),
    };
    final result = await _createPromoCode(CreatePromoCodeParams(data));
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderPromoStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (promo) {
        final updatedList = List<PromoCode>.from(state.promoCodes)
          ..insert(0, promo);
        emit(
          state.copyWith(
            status: ProviderPromoStatus.submitSuccess,
            promoCodes: updatedList,
          ),
        );
      },
    );
  }

  Future<void> updatePromo({
    required String promoId,
    String? description,
    double? minBookingAmount,
    int? maxUses,
    double? maxDiscountAmount,
    DateTime? expiresAt,
    bool? isActive,
  }) async {
    emit(state.copyWith(status: ProviderPromoStatus.submitting));
    final data = <String, dynamic>{};
    if (description != null) data['description'] = description;
    if (minBookingAmount != null) data['min_booking_amount'] = minBookingAmount;
    if (maxUses != null) data['max_uses'] = maxUses;
    if (maxDiscountAmount != null) {
      data['max_discount_amount'] = maxDiscountAmount;
    }
    if (expiresAt != null) {
      data['expires_at'] = expiresAt.toUtc().toIso8601String();
    }
    if (isActive != null) data['is_active'] = isActive;

    final result = await _updatePromoCode(
      UpdatePromoCodeParams(promoId: promoId, data: data),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderPromoStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedPromo) {
        final updatedList = state.promoCodes.map((p) {
          return p.id == promoId ? updatedPromo : p;
        }).toList();
        emit(
          state.copyWith(
            status: ProviderPromoStatus.submitSuccess,
            promoCodes: updatedList,
          ),
        );
      },
    );
  }

  Future<void> updatePromoData(
    String promoId,
    Map<String, dynamic> data,
  ) async {
    emit(state.copyWith(status: ProviderPromoStatus.submitting));

    final result = await _updatePromoCode(
      UpdatePromoCodeParams(promoId: promoId, data: data),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderPromoStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedPromo) {
        final updatedList = state.promoCodes.map((p) {
          return p.id == promoId ? updatedPromo : p;
        }).toList();
        emit(
          state.copyWith(
            status: ProviderPromoStatus.submitSuccess,
            promoCodes: updatedList,
          ),
        );
      },
    );
  }

  Future<void> deactivatePromo(String promoId) async {
    emit(state.copyWith(status: ProviderPromoStatus.submitting));

    final result = await _deactivatePromoCode(
      DeactivatePromoCodeParams(promoId: promoId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderPromoStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedPromo) {
        final updatedList = state.promoCodes.map((p) {
          return p.id == promoId ? updatedPromo : p;
        }).toList();
        emit(
          state.copyWith(
            status: ProviderPromoStatus.submitSuccess,
            promoCodes: updatedList,
          ),
        );
      },
    );
  }
}
