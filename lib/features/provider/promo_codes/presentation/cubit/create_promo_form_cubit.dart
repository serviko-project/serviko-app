import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePromoFormState {
  final String discountType;
  final DateTime? expiresAt;

  const CreatePromoFormState({required this.discountType, this.expiresAt});

  CreatePromoFormState copyWith({
    String? discountType,
    DateTime? expiresAt,
    bool clearExpiresAt = false,
  }) {
    return CreatePromoFormState(
      discountType: discountType ?? this.discountType,
      expiresAt: clearExpiresAt ? null : (expiresAt ?? this.expiresAt),
    );
  }
}

class CreatePromoFormCubit extends Cubit<CreatePromoFormState> {
  CreatePromoFormCubit()
    : super(const CreatePromoFormState(discountType: 'percentage'));

  void setDiscountType(String type) {
    emit(state.copyWith(discountType: type));
  }

  void setExpiresAt(DateTime? date) {
    emit(state.copyWith(expiresAt: date, clearExpiresAt: date == null));
  }
}
