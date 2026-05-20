import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:serviko_app/features/user/payment/domain/entities/payment_order_entity.dart';

// Razorpay Payment Handler
class RazorpayPaymentHandler {
  final Razorpay _razorpay = Razorpay();
  final void Function(PaymentSuccessResponse) onSuccess;
  final void Function(PaymentFailureResponse) onError;
  final void Function(ExternalWalletResponse)? onExternalWallet;

  RazorpayPaymentHandler({
    required this.onSuccess,
    required this.onError,
    this.onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    if (onExternalWallet != null) {
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  // Opens Checkout overlay
  void openCheckout(PaymentOrderEntity order) {
    final options = {
      'key': order.razorpayKeyId,
      'amount': order.amount,
      'currency': order.currency,
      'name': 'Serviko',
      'description': order.description,
      'order_id': order.razorpayOrderId,
      'prefill': {
        'name': order.customerName ?? '',
        'email': order.customerEmail ?? '',
        'contact': order.customerPhone ?? '',
      },
      'theme': {'color': '#6C3CE1'},
    };
    _razorpay.open(options);
  }

  // Event callbacks
  void _handleSuccess(PaymentSuccessResponse response) => onSuccess(response);
  void _handleError(PaymentFailureResponse response) => onError(response);
  void _handleExternalWallet(ExternalWalletResponse response) =>
      onExternalWallet?.call(response);

  void dispose() => _razorpay.clear();
}
