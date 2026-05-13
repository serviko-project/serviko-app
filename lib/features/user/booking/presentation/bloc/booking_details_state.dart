import 'package:equatable/equatable.dart';

class BookingDetailsState extends Equatable {
  final DateTime selectedDate;
  final int workingHours;
  final String selectedStartTime;
  final String promoCode;
  final double basePrice;

  const BookingDetailsState({
    required this.selectedDate,
    this.workingHours = 0,
    this.selectedStartTime = '',
    this.promoCode = '',
    this.basePrice = 0.0,
  });

  BookingDetailsState copyWith({
    DateTime? selectedDate,
    int? workingHours,
    String? selectedStartTime,
    String? promoCode,
    double? basePrice,
  }) {
    return BookingDetailsState(
      selectedDate: selectedDate ?? this.selectedDate,
      workingHours: workingHours ?? this.workingHours,
      selectedStartTime: selectedStartTime ?? this.selectedStartTime,
      promoCode: promoCode ?? this.promoCode,
      basePrice: basePrice ?? this.basePrice,
    );
  }

  double get totalPrice => basePrice * workingHours;

  @override
  List<Object?> get props => [
    selectedDate,
    workingHours,
    selectedStartTime,
    promoCode,
    basePrice,
  ];
}
