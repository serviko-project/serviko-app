import '../../domain/entities/payment_order_entity.dart';

class PaymentOrderModel extends PaymentOrderEntity {
  const PaymentOrderModel({
    required super.paymentId,
    required super.bookingId,
    required super.razorpayKeyId,
    required super.razorpayOrderId,
    required super.amount,
    required super.amountRupees,
    required super.currency,
    super.customerName,
    super.customerEmail,
    super.customerPhone,
    required super.description,
  });

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) {
    return PaymentOrderModel(
      paymentId: (json['payment_id'] as String?) ?? '',
      bookingId: (json['booking_id'] as String?) ?? '',
      razorpayKeyId: (json['razorpay_key_id'] as String?) ?? '',
      razorpayOrderId: (json['razorpay_order_id'] as String?) ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      amountRupees: (json['amount_rupees'] as num?)?.toDouble() ?? 0.0,
      currency: (json['currency'] as String?) ?? 'INR',
      customerName: json['customer_name'] as String?,
      customerEmail: json['customer_email'] as String?,
      customerPhone: json['customer_phone'] as String?,
      description: (json['description'] as String?) ?? 'Serviko payment',
    );
  }
}
