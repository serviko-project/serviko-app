import 'package:serviko_app/features/provider/earnings/data/datasources/earnings_remote_datasource.dart';
import 'package:serviko_app/features/provider/earnings/data/repositories/earnings_repository_impl.dart';
import 'package:serviko_app/features/provider/earnings/domain/usecases/get_earnings_summary_usecase.dart';
import 'package:serviko_app/features/provider/earnings/domain/usecases/cash_out_usecase.dart';
import 'package:serviko_app/features/provider/earnings/domain/usecases/get_transactions_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/data/datasources/provider_onboarding_remote_datasource.dart';
import 'package:serviko_app/features/provider/onboarding/data/repositories/provider_onboarding_repository_impl.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/delete_document_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_categories_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_my_provider_profile_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/reapply_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_application_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/submit_category_request_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/update_provider_details_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/upload_banner_image_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/delete_banner_image_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/upload_document_usecase.dart';
import 'package:serviko_app/injection_container.dart';

import 'package:serviko_app/features/provider/promo_codes/data/datasources/promo_code_remote_datasource.dart';
import 'package:serviko_app/features/provider/promo_codes/data/repositories/promo_code_repository_impl.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/get_promo_codes_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/create_promo_code_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/update_promo_code_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/deactivate_promo_code_usecase.dart';

// Extension to modularize provider onboarding dependencies
extension ProviderDI on InjectionContainer {
  void initProviderOnboarding() {
    // Provider Onboarding - Data
    providerOnboardingRemoteDataSource = ProviderOnboardingRemoteDataSourceImpl(
      apiClient: apiClient,
    );
    providerOnboardingRepository = ProviderOnboardingRepositoryImpl(
      remoteDataSource: providerOnboardingRemoteDataSource,
      networkInfo: networkInfo,
    );

    // Provider Onboarding - Use Cases
    submitApplicationUseCase = SubmitApplicationUseCase(
      providerOnboardingRepository,
    );
    getMyProviderProfileUseCase = GetMyProviderProfileUseCase(
      providerOnboardingRepository,
    );
    uploadDocumentUseCase = UploadDocumentUseCase(providerOnboardingRepository);
    deleteDocumentUseCase = DeleteDocumentUseCase(providerOnboardingRepository);
    reapplyUseCase = ReapplyUseCase(providerOnboardingRepository);
    getCategoriesUseCase = GetCategoriesUseCase(providerOnboardingRepository);
    updateProviderDetailsUseCase = UpdateProviderDetailsUseCase(
      providerOnboardingRepository,
    );
    uploadBannerImageUseCase = UploadBannerImageUseCase(
      providerOnboardingRepository,
    );
    deleteBannerImageUseCase = DeleteBannerImageUseCase(
      providerOnboardingRepository,
    );
    submitCategoryRequestUseCase = SubmitCategoryRequestUseCase(
      providerOnboardingRepository,
    );

    // Provider Promo Codes
    promoCodeRemoteDataSource = PromoCodeRemoteDataSourceImpl(
      apiClient: apiClient,
    );
    promoCodeRepository = PromoCodeRepositoryImpl(
      remoteDataSource: promoCodeRemoteDataSource,
      networkInfo: networkInfo,
    );
    getPromoCodesUseCase = GetPromoCodesUseCase(promoCodeRepository);
    createPromoCodeUseCase = CreatePromoCodeUseCase(promoCodeRepository);
    updatePromoCodeUseCase = UpdatePromoCodeUseCase(promoCodeRepository);
    deactivatePromoCodeUseCase = DeactivatePromoCodeUseCase(
      promoCodeRepository,
    );

    // Provider Earnings
    earningsRemoteDataSource = EarningsRemoteDataSourceImpl(
      apiClient: apiClient,
    );
    earningsRepository = EarningsRepositoryImpl(
      remoteDataSource: earningsRemoteDataSource,
      networkInfo: networkInfo,
    );
    getEarningsSummaryUseCase = GetEarningsSummaryUseCase(
      repository: earningsRepository,
    );
    cashOutUseCase = CashOutUseCase(repository: earningsRepository);
    getTransactionsUseCase = GetTransactionsUseCase(earningsRepository);
  }
}
