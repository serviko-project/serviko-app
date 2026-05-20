import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String bookingId;
  final double amount;
  final String currency;
  final String status;
  final String gateway;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? paidAt;
  final String? refundedAt;
  final String createdAt;
  final String updatedAt;

  const PaymentEntity({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.gateway,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.paidAt,
    this.refundedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    bookingId,
    amount,
    currency,
    status,
    gateway,
    razorpayOrderId,
    razorpayPaymentId,
    paidAt,
    refundedAt,
    createdAt,
    updatedAt,
  ];
}
