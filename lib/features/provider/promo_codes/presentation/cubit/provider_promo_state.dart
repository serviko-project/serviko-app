import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';

enum ProviderPromoStatus {
  initial,
  loading,
  success,
  failure,
  submitting,
  submitSuccess,
}

class ProviderPromoState extends Equatable {
  final ProviderPromoStatus status;
  final List<PromoCode> promoCodes;
  final String? errorMessage;

  const ProviderPromoState({
    this.status = ProviderPromoStatus.initial,
    this.promoCodes = const [],
    this.errorMessage,
  });

  ProviderPromoState copyWith({
    ProviderPromoStatus? status,
    List<PromoCode>? promoCodes,
    String? errorMessage,
  }) {
    return ProviderPromoState(
      status: status ?? this.status,
      promoCodes: promoCodes ?? this.promoCodes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, promoCodes, errorMessage];
}
