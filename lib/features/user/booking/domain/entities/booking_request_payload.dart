import 'package:serviko_app/features/user/booking/domain/entities/booking_init_data.dart';

class BookingRequestPayload {
  final BookingInitData initData;
  final DateTime selectedDate;
  final int workingHours;
  final String selectedStartTime;
  final String promoCode;
  final double discountAmount;
  final double totalPrice;
  final double? customerLatitude;
  final double? customerLongitude;
  final String? customerAddress;

  BookingRequestPayload({
    required this.initData,
    required this.selectedDate,
    required this.workingHours,
    required this.selectedStartTime,
    required this.promoCode,
    required this.discountAmount,
    required this.totalPrice,
    this.customerLatitude,
    this.customerLongitude,
    this.customerAddress,
  });

  BookingRequestPayload copyWith({
    double? customerLatitude,
    double? customerLongitude,
    String? customerAddress,
  }) {
    return BookingRequestPayload(
      initData: initData,
      selectedDate: selectedDate,
      workingHours: workingHours,
      selectedStartTime: selectedStartTime,
      promoCode: promoCode,
      discountAmount: discountAmount,
      totalPrice: totalPrice,
      customerLatitude: customerLatitude ?? this.customerLatitude,
      customerLongitude: customerLongitude ?? this.customerLongitude,
      customerAddress: customerAddress ?? this.customerAddress,
    );
  }
}
