import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';

enum BookingDetailsStatus { initial, loading, success, failure }

class BookingDetailsState extends Equatable {
  final BookingDetailsStatus status;
  final DateTime selectedDate;
  final int workingHours;
  final String selectedStartTime;
  final List<String> availableStartTimes;
  final List<String> allStartTimes;
  final Map<String, int> maxDurationFromSlot;
  final PromoCode? appliedPromo;
  final double basePrice;
  final String? errorMessage;

  const BookingDetailsState({
    this.status = BookingDetailsStatus.initial,
    required this.selectedDate,
    this.workingHours = 1,
    this.selectedStartTime = '',
    this.availableStartTimes = const [],
    this.allStartTimes = const [],
    this.maxDurationFromSlot = const {},
    this.appliedPromo,
    this.basePrice = 0.0,
    this.errorMessage,
  });

  BookingDetailsState copyWith({
    BookingDetailsStatus? status,
    DateTime? selectedDate,
    int? workingHours,
    String? selectedStartTime,
    List<String>? availableStartTimes,
    List<String>? allStartTimes,
    Map<String, int>? maxDurationFromSlot,
    PromoCode? appliedPromo,
    bool clearPromo = false,
    double? basePrice,
    String? errorMessage,
  }) {
    return BookingDetailsState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      workingHours: workingHours ?? this.workingHours,
      selectedStartTime: selectedStartTime ?? this.selectedStartTime,
      availableStartTimes: availableStartTimes ?? this.availableStartTimes,
      allStartTimes: allStartTimes ?? this.allStartTimes,
      maxDurationFromSlot: maxDurationFromSlot ?? this.maxDurationFromSlot,
      appliedPromo: clearPromo ? null : (appliedPromo ?? this.appliedPromo),
      basePrice: basePrice ?? this.basePrice,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double get subTotal => basePrice * workingHours;

  double get discountAmount {
    if (appliedPromo == null) return 0.0;

    // Check if subTotal meets minimum booking amount
    final minAmount = appliedPromo!.minBookingAmount ?? 0.0;
    if (minAmount > 0 && subTotal < minAmount) {
      return 0.0;
    }

    final isPercentage =
        appliedPromo!.discountType.toLowerCase() == 'percentage';

    if (isPercentage) {
      double calculatedDiscount =
          subTotal * (appliedPromo!.discountValue / 100);
      if (appliedPromo!.maxDiscountAmount != null &&
          calculatedDiscount > appliedPromo!.maxDiscountAmount!) {
        return appliedPromo!.maxDiscountAmount!;
      }
      return calculatedDiscount;
    } else {
      return appliedPromo!.discountValue < subTotal
          ? appliedPromo!.discountValue
          : subTotal;
    }
  }

  double get totalPrice => subTotal - discountAmount;

  // Check if selected duration conflicts with the next booking
  bool get hasConflict {
    if (selectedStartTime.isEmpty) return false;
    final maxDur = maxDurationFromSlot[selectedStartTime];
    if (maxDur == null) return false;
    return workingHours > maxDur;
  }

  // Max duration the user can book from the selected slot
  int get maxBookableHours {
    if (selectedStartTime.isEmpty) return 8;
    return maxDurationFromSlot[selectedStartTime] ?? 8;
  }

  bool get canContinue =>
      status == BookingDetailsStatus.success &&
      selectedStartTime.isNotEmpty &&
      !hasConflict;

  @override
  List<Object?> get props => [
    status,
    selectedDate,
    workingHours,
    selectedStartTime,
    availableStartTimes,
    allStartTimes,
    maxDurationFromSlot,
    appliedPromo,
    basePrice,
    errorMessage,
  ];
}
