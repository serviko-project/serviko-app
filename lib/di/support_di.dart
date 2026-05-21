import 'package:serviko_app/features/shared/support/data/datasources/support_remote_datasource.dart';
import 'package:serviko_app/features/shared/support/data/repositories/support_repository_impl.dart';
import 'package:serviko_app/features/shared/support/domain/usecases/get_faqs_usecase.dart';
import 'package:serviko_app/features/shared/support/domain/usecases/get_privacy_policy_usecase.dart';
import 'package:serviko_app/injection_container.dart';

// Extension to modularize support dependencies
extension SupportDI on InjectionContainer {
  void initSupport() {
    supportRemoteDataSource = SupportRemoteDataSourceImpl(apiClient: apiClient);
    supportRepository = SupportRepositoryImpl(
      remoteDataSource: supportRemoteDataSource,
      networkInfo: networkInfo,
    );
    getFAQsUseCase = GetFAQsUseCase(supportRepository);
    getPrivacyPolicyUseCase = GetPrivacyPolicyUseCase(supportRepository);
  }
}
