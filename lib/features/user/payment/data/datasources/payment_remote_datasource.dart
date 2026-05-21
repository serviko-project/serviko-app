import 'package:serviko_app/core/network/api_client.dart';
import '../models/payment_model.dart';
import '../models/payment_order_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentOrderModel> createBookingPaymentOrder({
    required String bookingId,
  });

  Future<PaymentModel> verifyPayment({
    required String bookingId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient apiClient;

  PaymentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaymentOrderModel> createBookingPaymentOrder({
    required String bookingId,
  }) {
    return apiClient.request(
      call: () =>
          apiClient.dio.post('/api/v1/payments/bookings/$bookingId/order'),
      parser: (data) =>
          PaymentOrderModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<PaymentModel> verifyPayment({
    required String bookingId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) {
    return apiClient.request(
      call: () => apiClient.dio.post(
        '/api/v1/payments/verify',
        data: {
          'booking_id': bookingId,
          'razorpay_order_id': razorpayOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
        },
      ),
      parser: (data) => PaymentModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
