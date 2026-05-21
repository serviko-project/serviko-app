import 'package:equatable/equatable.dart';

class PaymentOrderEntity extends Equatable {
  final String paymentId;
  final String bookingId;
  final String razorpayKeyId;
  final String razorpayOrderId;
  final int amount;
  final double amountRupees;
  final String currency;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String description;

  const PaymentOrderEntity({
    required this.paymentId,
    required this.bookingId,
    required this.razorpayKeyId,
    required this.razorpayOrderId,
    required this.amount,
    required this.amountRupees,
    required this.currency,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    required this.description,
  });

  @override
  List<Object?> get props => [
    paymentId,
    bookingId,
    razorpayKeyId,
    razorpayOrderId,
    amount,
    amountRupees,
    currency,
    customerName,
    customerEmail,
    customerPhone,
    description,
  ];
}
