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
  final String? customerFirebaseUid;
  final String? providerName;
  final String? providerImage;
  final String? providerFirebaseUid;
  final String? categoryName;
  final String? confirmedAt;
  final String? rejectedAt;
  final String? cancelledAt;
  final String? completedAt;
  final String? completionNote;
  final bool hasReview;
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
    this.customerFirebaseUid,
    this.providerName,
    this.providerImage,
    this.providerFirebaseUid,
    this.categoryName,
    this.confirmedAt,
    this.rejectedAt,
    this.cancelledAt,
    this.completedAt,
    this.completionNote,
    this.hasReview = false,
    this.paymentStatus = 'unpaid',
    this.paymentId,
    this.paymentReference,
    this.paidAt,
    this.refundedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  BookingEntity copyWith({
    String? id,
    String? customerId,
    String? providerId,
    String? serviceId,
    String? scheduledDate,
    String? startTime,
    String? endTime,
    int? durationHours,
    double? basePricePerHour,
    double? totalPrice,
    BookingStatus? status,
    double? customerLatitude,
    double? customerLongitude,
    String? customerAddress,
    String? rejectionReason,
    String? customerName,
    String? customerImage,
    String? customerFirebaseUid,
    String? providerName,
    String? providerImage,
    String? providerFirebaseUid,
    String? categoryName,
    String? confirmedAt,
    String? rejectedAt,
    String? cancelledAt,
    String? completedAt,
    String? completionNote,
    bool? hasReview,
    String? paymentStatus,
    String? paymentId,
    String? paymentReference,
    String? paidAt,
    String? refundedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return BookingEntity(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      providerId: providerId ?? this.providerId,
      serviceId: serviceId ?? this.serviceId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationHours: durationHours ?? this.durationHours,
      basePricePerHour: basePricePerHour ?? this.basePricePerHour,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      customerLatitude: customerLatitude ?? this.customerLatitude,
      customerLongitude: customerLongitude ?? this.customerLongitude,
      customerAddress: customerAddress ?? this.customerAddress,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      customerName: customerName ?? this.customerName,
      customerImage: customerImage ?? this.customerImage,
      customerFirebaseUid: customerFirebaseUid ?? this.customerFirebaseUid,
      providerName: providerName ?? this.providerName,
      providerImage: providerImage ?? this.providerImage,
      providerFirebaseUid: providerFirebaseUid ?? this.providerFirebaseUid,
      categoryName: categoryName ?? this.categoryName,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      completedAt: completedAt ?? this.completedAt,
      completionNote: completionNote ?? this.completionNote,
      hasReview: hasReview ?? this.hasReview,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentId: paymentId ?? this.paymentId,
      paymentReference: paymentReference ?? this.paymentReference,
      paidAt: paidAt ?? this.paidAt,
      refundedAt: refundedAt ?? this.refundedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
    customerFirebaseUid,
    providerName,
    providerImage,
    providerFirebaseUid,
    categoryName,
    confirmedAt,
    rejectedAt,
    cancelledAt,
    completedAt,
    completionNote,
    hasReview,
    paymentStatus,
    paymentId,
    paymentReference,
    paidAt,
    refundedAt,
    createdAt,
    updatedAt,
  ];
}
