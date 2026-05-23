import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';

enum BookingPromosStatus { initial, loading, success, failure }

class BookingPromosState extends Equatable {
  final BookingPromosStatus status;
  final List<PromoCode> promos;
  final String? errorMessage;

  const BookingPromosState({
    this.status = BookingPromosStatus.initial,
    this.promos = const [],
    this.errorMessage,
  });

  BookingPromosState copyWith({
    BookingPromosStatus? status,
    List<PromoCode>? promos,
    String? errorMessage,
  }) {
    return BookingPromosState(
      status: status ?? this.status,
      promos: promos ?? this.promos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, promos, errorMessage];
}
