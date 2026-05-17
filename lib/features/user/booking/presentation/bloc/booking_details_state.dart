import 'package:equatable/equatable.dart';

enum BookingDetailsStatus { initial, loading, success, failure }

class BookingDetailsState extends Equatable {
  final BookingDetailsStatus status;
  final DateTime selectedDate;
  final int workingHours;
  final String selectedStartTime;
  final List<String> availableStartTimes;
  final Map<String, int> maxDurationFromSlot;
  final String promoCode;
  final double basePrice;
  final String? errorMessage;

  const BookingDetailsState({
    this.status = BookingDetailsStatus.initial,
    required this.selectedDate,
    this.workingHours = 1,
    this.selectedStartTime = '',
    this.availableStartTimes = const [],
    this.maxDurationFromSlot = const {},
    this.promoCode = '',
    this.basePrice = 0.0,
    this.errorMessage,
  });

  BookingDetailsState copyWith({
    BookingDetailsStatus? status,
    DateTime? selectedDate,
    int? workingHours,
    String? selectedStartTime,
    List<String>? availableStartTimes,
    Map<String, int>? maxDurationFromSlot,
    String? promoCode,
    double? basePrice,
    String? errorMessage,
  }) {
    return BookingDetailsState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      workingHours: workingHours ?? this.workingHours,
      selectedStartTime: selectedStartTime ?? this.selectedStartTime,
      availableStartTimes: availableStartTimes ?? this.availableStartTimes,
      maxDurationFromSlot: maxDurationFromSlot ?? this.maxDurationFromSlot,
      promoCode: promoCode ?? this.promoCode,
      basePrice: basePrice ?? this.basePrice,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double get totalPrice => basePrice * workingHours;

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
    maxDurationFromSlot,
    promoCode,
    basePrice,
    errorMessage,
  ];
}
