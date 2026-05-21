import 'package:serviko_app/features/user/payment/data/datasources/payment_remote_datasource.dart';
import 'package:serviko_app/features/user/payment/data/repositories/payment_repository_impl.dart';
import 'package:serviko_app/features/user/payment/domain/usecases/create_payment_order_usecase.dart';
import 'package:serviko_app/features/user/payment/domain/usecases/verify_payment_usecase.dart';
import 'package:serviko_app/injection_container.dart';

// Extension to modularize payment dependencies
extension PaymentDI on InjectionContainer {
  void initPayment() {
    paymentRemoteDataSource = PaymentRemoteDataSourceImpl(apiClient: apiClient);
    paymentRepository = PaymentRepositoryImpl(
      remoteDataSource: paymentRemoteDataSource,
      networkInfo: networkInfo,
    );
    createPaymentOrderUseCase = CreatePaymentOrderUseCase(paymentRepository);
    verifyPaymentUseCase = VerifyPaymentUseCase(paymentRepository);
  }
}
