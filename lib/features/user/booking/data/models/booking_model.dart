import '../../domain/entities/booking_entity.dart';
import '../../domain/enums/booking_status.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.customerId,
    required super.providerId,
    required super.serviceId,
    required super.scheduledDate,
    required super.startTime,
    required super.endTime,
    required super.durationHours,
    required super.basePricePerHour,
    required super.totalPrice,
    required super.status,
    super.customerLatitude,
    super.customerLongitude,
    super.customerAddress,
    super.rejectionReason,
    super.customerName,
    super.customerImage,
    super.customerFirebaseUid,
    super.providerName,
    super.providerImage,
    super.providerFirebaseUid,
    super.categoryName,
    super.confirmedAt,
    super.rejectedAt,
    super.cancelledAt,
    super.completedAt,
    super.completionNote,
    super.hasReview,
    super.paymentStatus,
    super.paymentId,
    super.paymentReference,
    super.paidAt,
    super.refundedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['id'] as String?) ?? '',
      customerId: (json['customer_id'] as String?) ?? '',
      providerId: (json['provider_id'] as String?) ?? '',
      serviceId: (json['service_id'] as String?) ?? '',
      scheduledDate: (json['scheduled_date'] as String?) ?? '',
      startTime: (json['start_time'] as String?) ?? '',
      endTime: (json['end_time'] as String?) ?? '',
      durationHours: (json['duration_hours'] as num?)?.toInt() ?? 0,
      basePricePerHour:
          (json['base_price_per_hour'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: BookingStatus.fromString((json['status'] as String?) ?? ''),
      customerLatitude: json['customer_latitude'] != null
          ? (json['customer_latitude'] as num).toDouble()
          : null,
      customerLongitude: json['customer_longitude'] != null
          ? (json['customer_longitude'] as num).toDouble()
          : null,
      customerAddress: json['customer_address'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      customerName: json['customer_name'] as String?,
      customerImage: json['customer_image'] as String?,
      customerFirebaseUid: json['customer_firebase_uid'] as String?,
      providerName: json['provider_name'] as String?,
      providerImage: json['provider_image'] as String?,
      providerFirebaseUid: json['provider_firebase_uid'] as String?,
      categoryName: json['category_name'] as String?,
      confirmedAt: json['confirmed_at'] as String?,
      rejectedAt: json['rejected_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      completedAt: json['completed_at'] as String?,
      completionNote: json['completion_note'] as String?,
      hasReview: json['has_review'] as bool? ?? false,
      paymentStatus: (json['payment_status'] as String?) ?? 'unpaid',
      paymentId: json['payment_id'] as String?,
      paymentReference: json['payment_reference'] as String?,
      paidAt: json['paid_at'] as String?,
      refundedAt: json['refunded_at'] as String?,
      createdAt: (json['created_at'] as String?) ?? '',
      updatedAt: (json['updated_at'] as String?) ?? '',
    );
  }
}
