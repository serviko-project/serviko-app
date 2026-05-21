import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';

class BookingEntity extends Equatable {
  final String id;
  final String customerId;
  final String providerId;
  final String serviceId;
  final String scheduledDate;
  final String startTime;
  final String endTime;
  final int durationHours;
  final double basePricePerHour;
  final double totalPrice;
  final BookingStatus status;
  final double? customerLatitude;
  final double? customerLongitude;
  final String? customerAddress;
  final String? rejectionReason;
  final String? customerName;
  final String? customerImage;
  final String? providerName;
  final String? providerImage;
  final String? categoryName;
  final String? confirmedAt;
  final String? rejectedAt;
  final String? cancelledAt;
  final String paymentStatus;
  final String? paymentId;
  final String? paymentReference;
  final String? paidAt;
  final String? refundedAt;
  final String createdAt;
  final String updatedAt;

  const BookingEntity({
    required this.id,
    required this.customerId,
    required this.providerId,
    required this.serviceId,
    required this.scheduledDate,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.basePricePerHour,
    required this.totalPrice,
    required this.status,
    this.customerLatitude,
    this.customerLongitude,
    this.customerAddress,
    this.rejectionReason,
    this.customerName,
    this.customerImage,
    this.providerName,
    this.providerImage,
    this.categoryName,
    this.confirmedAt,
    this.rejectedAt,
    this.cancelledAt,
    this.paymentStatus = 'unpaid',
    this.paymentId,
    this.paymentReference,
    this.paidAt,
    this.refundedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    customerId,
    providerId,
    serviceId,
    scheduledDate,
    startTime,
    endTime,
    durationHours,
    basePricePerHour,
    totalPrice,
    status,
    customerLatitude,
    customerLongitude,
    customerAddress,
    rejectionReason,
    customerName,
    customerImage,
    providerName,
    providerImage,
    categoryName,
    confirmedAt,
    rejectedAt,
    cancelledAt,
    paymentStatus,
    paymentId,
    paymentReference,
    paidAt,
    refundedAt,
    createdAt,
    updatedAt,
  ];
}
