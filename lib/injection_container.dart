import 'package:serviko_app/features/shared/support/data/datasources/support_remote_datasource.dart';
import 'package:serviko_app/features/shared/support/domain/repositories/support_repository.dart';
import 'package:serviko_app/features/shared/support/domain/usecases/get_faqs_usecase.dart';
import 'package:serviko_app/features/shared/support/domain/usecases/get_privacy_policy_usecase.dart';
import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/core/network/network_info.dart';
import 'package:serviko_app/features/shared/communication/data/datasources/zego_remote_datasource.dart';
import 'package:serviko_app/features/shared/communication/domain/repositories/communication_repository.dart';
import 'package:serviko_app/features/shared/communication/domain/usecases/get_provider_directory_usecase.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_service.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_token_manager.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';
import 'package:serviko_app/features/provider/onboarding/data/datasources/provider_onboarding_remote_datasource.dart';
import 'package:serviko_app/features/provider/onboarding/domain/repositories/provider_onboarding_repository.dart';
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
import 'package:serviko_app/features/provider/dashboard/data/datasources/provider_dashboard_remote_datasource.dart';
import 'package:serviko_app/features/provider/dashboard/domain/repositories/provider_dashboard_repository.dart';
import 'package:serviko_app/features/provider/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';

import 'package:serviko_app/features/user/auth/data/datasources/auth_local_datasource.dart';
import 'package:serviko_app/features/user/auth/data/datasources/auth_remote_datasource.dart';
import 'package:serviko_app/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/check_recovery_options_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/reset_password_with_phone_otp_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/sign_in_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/sign_out_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/sign_up_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/start_phone_reset_otp_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/verify_phone_reset_otp_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/update_firebase_display_name_usecase.dart';
import 'package:serviko_app/features/user/profile/data/datasources/profile_local_datasource.dart';
import 'package:serviko_app/features/user/profile/data/datasources/profile_remote_datasource.dart';
import 'package:serviko_app/features/user/profile/domain/repositories/profile_repository.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/create_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_cached_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/update_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/upload_profile_image_usecase.dart';

import 'package:serviko_app/features/provider/promo_codes/data/datasources/promo_code_remote_datasource.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/repositories/promo_code_repository.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/get_promo_codes_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/create_promo_code_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/update_promo_code_usecase.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/usecases/deactivate_promo_code_usecase.dart';

import 'package:serviko_app/features/provider/earnings/data/datasources/earnings_remote_datasource.dart';
import 'package:serviko_app/features/provider/earnings/domain/repositories/earnings_repository.dart';
import 'package:serviko_app/features/provider/earnings/domain/usecases/get_earnings_summary_usecase.dart';
import 'package:serviko_app/features/provider/earnings/domain/usecases/cash_out_usecase.dart';
import 'package:serviko_app/features/provider/earnings/domain/usecases/get_transactions_usecase.dart';

import 'package:serviko_app/features/user/category/data/datasources/category_remote_data_source.dart';
import 'package:serviko_app/features/user/category/domain/repositories/category_repository.dart';
import 'package:serviko_app/features/user/category/domain/usecases/get_categories_usecase.dart'
    as user_category;

import 'package:serviko_app/features/user/service/data/datasources/service_remote_data_source.dart';
import 'package:serviko_app/features/user/service/domain/repositories/service_repository.dart';
import 'package:serviko_app/features/user/service/domain/usecases/get_popular_services_usecase.dart';
import 'package:serviko_app/features/user/service/domain/usecases/get_service_detail_usecase.dart';

import 'package:serviko_app/features/user/search/data/datasources/search_remote_data_source.dart';
import 'package:serviko_app/features/user/search/domain/repositories/search_repository.dart';
import 'package:serviko_app/features/user/search/domain/usecases/search_services_usecase.dart';

import 'package:serviko_app/features/user/booking/data/datasources/booking_remote_data_source.dart';
import 'package:serviko_app/features/user/booking/domain/repositories/booking_repository.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/create_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_available_slots_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_bookings_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_reviews_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_promos_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/review_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_booking_detail_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/complete_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_customer_bookings_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/submit_review_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/validate_promo_code_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_active_promo_codes_usecase.dart';
import 'package:serviko_app/features/user/payment/data/datasources/payment_remote_datasource.dart';
import 'package:serviko_app/features/user/payment/domain/repositories/payment_repository.dart';
import 'package:serviko_app/features/user/payment/domain/usecases/create_payment_order_usecase.dart';
import 'package:serviko_app/features/user/payment/domain/usecases/verify_payment_usecase.dart';

// Extensions for modular DI
import 'di/core_di.dart';
import 'di/communication_di.dart';
import 'di/auth_di.dart';
import 'di/profile_di.dart';
import 'di/provider_di.dart';
import 'di/services_di.dart';
import 'di/booking_di.dart';
import 'di/payment_di.dart';
import 'di/support_di.dart';

class InjectionContainer {
  InjectionContainer._();

  static final InjectionContainer _instance = InjectionContainer._();
  static InjectionContainer get instance => _instance;

  // Core
  late final ApiClient apiClient;
  late final NetworkInfo networkInfo;
  late final LocationService locationService;

  // Communication
  late final ZegoRemoteDataSource zegoRemoteDataSource;
  late final CommunicationRepository communicationRepository;
  late final GetProviderDirectoryUseCase getProviderDirectoryUseCase;
  late final ZegoTokenManager zegoTokenManager;
  late final ZegoService zegoService;

  // Auth
  late final AuthLocalDataSource authLocalDataSource;
  late final AuthRemoteDataSource authRemoteDataSource;
  late final AuthRepository authRepository;
  late final SignInUseCase signInUseCase;
  late final SignUpUseCase signUpUseCase;
  late final GoogleSignInUseCase googleSignInUseCase;
  late final ForgotPasswordUseCase forgotPasswordUseCase;
  late final CheckRecoveryOptionsUseCase checkRecoveryOptionsUseCase;
  late final StartPhoneResetOtpUseCase startPhoneResetOtpUseCase;
  late final VerifyPhoneResetOtpUseCase verifyPhoneResetOtpUseCase;
  late final ResetPasswordWithPhoneOtpUseCase resetPasswordWithPhoneOtpUseCase;
  late final SignOutUseCase signOutUseCase;
  late final GetCurrentUserUseCase getCurrentUserUseCase;
  late final UpdateFirebaseDisplayNameUseCase updateFirebaseDisplayNameUseCase;

  // Profile
  late final ProfileLocalDataSource profileLocalDataSource;
  late final ProfileRemoteDataSource profileRemoteDataSource;
  late final UserProfileRepository userProfileRepository;
  late final CreateUserProfileUseCase createUserProfileUseCase;
  late final GetMyProfileUseCase getMyProfileUseCase;
  late final GetCachedProfileUseCase getCachedProfileUseCase;
  late final UpdateProfileUseCase updateProfileUseCase;
  late final UploadProfileImageUseCase uploadProfileImageUseCase;
  late final DeleteProfileImageUseCase deleteProfileImageUseCase;

  // Provider Onboarding
  late final ProviderOnboardingRemoteDataSource
  providerOnboardingRemoteDataSource;
  late final ProviderOnboardingRepository providerOnboardingRepository;
  late final SubmitApplicationUseCase submitApplicationUseCase;
  late final GetMyProviderProfileUseCase getMyProviderProfileUseCase;
  late final UploadDocumentUseCase uploadDocumentUseCase;
  late final DeleteDocumentUseCase deleteDocumentUseCase;
  late final ReapplyUseCase reapplyUseCase;
  late final GetCategoriesUseCase getCategoriesUseCase;
  late final UpdateProviderDetailsUseCase updateProviderDetailsUseCase;
  late final UploadBannerImageUseCase uploadBannerImageUseCase;
  late final DeleteBannerImageUseCase deleteBannerImageUseCase;
  late final SubmitCategoryRequestUseCase submitCategoryRequestUseCase;

  // Provider Dashboard
  late final ProviderDashboardRemoteDataSource
  providerDashboardRemoteDataSource;
  late final ProviderDashboardRepository providerDashboardRepository;
  late final GetDashboardStatsUseCase getDashboardStatsUseCase;

  // Promo Codes
  late final PromoCodeRemoteDataSource promoCodeRemoteDataSource;
  late final PromoCodeRepository promoCodeRepository;
  late final GetPromoCodesUseCase getPromoCodesUseCase;
  late final CreatePromoCodeUseCase createPromoCodeUseCase;
  late final UpdatePromoCodeUseCase updatePromoCodeUseCase;
  late final DeactivatePromoCodeUseCase deactivatePromoCodeUseCase;

  // Provider Earnings
  late final EarningsRemoteDataSource earningsRemoteDataSource;
  late final EarningsRepository earningsRepository;
  late final GetEarningsSummaryUseCase getEarningsSummaryUseCase;
  late final CashOutUseCase cashOutUseCase;
  late final GetTransactionsUseCase getTransactionsUseCase;

  // User Category
  late final CategoryRemoteDataSource categoryRemoteDataSource;
  late final CategoryRepository categoryRepository;
  late final user_category.GetCategoriesUseCase userGetCategoriesUseCase;

  // User Service
  late final ServiceRemoteDataSource serviceRemoteDataSource;
  late final ServiceRepository serviceRepository;
  late final GetPopularServicesUseCase getPopularServicesUseCase;
  late final GetServiceDetailUseCase getServiceDetailUseCase;

  // Search
  late final SearchRemoteDataSource searchRemoteDataSource;
  late final SearchRepository searchRepository;
  late final SearchServicesUseCase searchServicesUseCase;

  // Booking
  late final BookingRemoteDataSource bookingRemoteDataSource;
  late final BookingRepository bookingRepository;
  late final GetAvailableSlotsUseCase getAvailableSlotsUseCase;
  late final GetProviderPromosUseCase getProviderPromosUseCase;
  late final GetActivePromoCodesUseCase getActivePromoCodesUseCase;
  late final CreateBookingUseCase createBookingUseCase;
  late final GetProviderBookingsUseCase getProviderBookingsUseCase;
  late final ReviewBookingUseCase reviewBookingUseCase;
  late final GetBookingDetailUseCase getBookingDetailUseCase;
  late final CancelBookingUseCase cancelBookingUseCase;
  late final CompleteBookingUseCase completeBookingUseCase;
  late final GetCustomerBookingsUseCase getCustomerBookingsUseCase;
  late final SubmitReviewUseCase submitReviewUseCase;
  late final GetProviderReviewsUseCase getProviderReviewsUseCase;
  late final ValidatePromoCodeUseCase validatePromoCodeUseCase;

  // Payment
  late final PaymentRemoteDataSource paymentRemoteDataSource;
  late final PaymentRepository paymentRepository;
  late final CreatePaymentOrderUseCase createPaymentOrderUseCase;
  late final VerifyPaymentUseCase verifyPaymentUseCase;

  // Support
  late final SupportRemoteDataSource supportRemoteDataSource;
  late final SupportRepository supportRepository;
  late final GetFAQsUseCase getFAQsUseCase;
  late final GetPrivacyPolicyUseCase getPrivacyPolicyUseCase;

  // Initialise
  Future<void> init() async {
    initCore();
    initCommunication();
    initAuth();
    initProfile();
    initProviderOnboarding();
    initServices();
    initBooking();
    initPayment();
    initSupport();
  }
}
