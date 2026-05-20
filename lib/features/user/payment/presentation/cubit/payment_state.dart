import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_order_entity.dart';

enum PaymentFlowStatus {
  initial,
  creatingOrder,
  orderCreated,
  verifying,
  verified,
  failure,
}

class PaymentState extends Equatable {
  final PaymentFlowStatus status;
  final PaymentOrderEntity? order;
  final PaymentEntity? payment;
  final String? message;

  const PaymentState({
    this.status = PaymentFlowStatus.initial,
    this.order,
    this.payment,
    this.message,
  });

  PaymentState copyWith({
    PaymentFlowStatus? status,
    PaymentOrderEntity? order,
    PaymentEntity? payment,
    String? message,
  }) {
    return PaymentState(
      status: status ?? this.status,
      order: order ?? this.order,
      payment: payment ?? this.payment,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, order, payment, message];
}
