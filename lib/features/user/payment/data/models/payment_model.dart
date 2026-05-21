import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.bookingId,
    required super.amount,
    required super.currency,
    required super.status,
    required super.gateway,
    super.razorpayOrderId,
    super.razorpayPaymentId,
    super.paidAt,
    super.refundedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: (json['id'] as String?) ?? '',
      bookingId: (json['booking_id'] as String?) ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: (json['currency'] as String?) ?? 'INR',
      status: (json['status'] as String?) ?? 'unpaid',
      gateway: (json['gateway'] as String?) ?? 'razorpay',
      razorpayOrderId: json['razorpay_order_id'] as String?,
      razorpayPaymentId: json['razorpay_payment_id'] as String?,
      paidAt: json['paid_at'] as String?,
      refundedAt: json['refunded_at'] as String?,
      createdAt: (json['created_at'] as String?) ?? '',
      updatedAt: (json['updated_at'] as String?) ?? '',
    );
  }
}
