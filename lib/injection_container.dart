import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:serviko_app/features/shared/support/data/datasources/support_remote_datasource.dart';
import 'package:serviko_app/features/shared/support/data/repositories/support_repository_impl.dart';
import 'package:serviko_app/features/shared/support/domain/repositories/support_repository.dart';
import 'package:serviko_app/features/shared/support/domain/usecases/get_faqs_usecase.dart';
import 'package:serviko_app/features/shared/support/domain/usecases/get_privacy_policy_usecase.dart';
import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/core/network/network_info.dart';
import 'package:serviko_app/features/shared/communication/data/datasources/zego_remote_datasource.dart';
import 'package:serviko_app/features/shared/communication/data/repositories/communication_repository_impl.dart';
import 'package:serviko_app/features/shared/communication/domain/repositories/communication_repository.dart';
import 'package:serviko_app/features/shared/communication/domain/usecases/get_provider_directory_usecase.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_service.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_token_manager.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';
import 'package:serviko_app/features/provider/onboarding/data/datasources/provider_onboarding_remote_datasource.dart';
import 'package:serviko_app/features/provider/onboarding/data/repositories/provider_onboarding_repository_impl.dart';
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
import 'package:serviko_app/features/user/auth/data/datasources/auth_local_datasource.dart';
import 'package:serviko_app/features/user/auth/data/datasources/auth_remote_datasource.dart';
import 'package:serviko_app/features/user/auth/data/repositories/auth_repository_impl.dart';
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
import 'package:serviko_app/features/user/profile/data/repositories/profile_repository_impl.dart';
import 'package:serviko_app/features/user/profile/domain/repositories/profile_repository.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/create_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_cached_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/update_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/upload_profile_image_usecase.dart';

import 'package:serviko_app/features/user/category/data/datasources/category_remote_data_source.dart';
import 'package:serviko_app/features/user/category/data/repositories/category_repository_impl.dart';
import 'package:serviko_app/features/user/category/domain/repositories/category_repository.dart';
import 'package:serviko_app/features/user/category/domain/usecases/get_categories_usecase.dart'
    as user_category;

import 'package:serviko_app/features/user/service/data/datasources/service_remote_data_source.dart';
import 'package:serviko_app/features/user/service/data/repositories/service_repository_impl.dart';
import 'package:serviko_app/features/user/service/domain/repositories/service_repository.dart';
import 'package:serviko_app/features/user/service/domain/usecases/get_popular_services_usecase.dart';
import 'package:serviko_app/features/user/service/domain/usecases/get_service_detail_usecase.dart';

import 'package:serviko_app/features/user/search/data/datasources/search_remote_data_source.dart';
import 'package:serviko_app/features/user/search/data/repositories/search_repository_impl.dart';
import 'package:serviko_app/features/user/search/domain/repositories/search_repository.dart';
import 'package:serviko_app/features/user/search/domain/usecases/search_services_usecase.dart';

import 'package:serviko_app/features/user/booking/data/datasources/booking_remote_data_source.dart';
import 'package:serviko_app/features/user/booking/data/repositories/booking_repository_impl.dart';
import 'package:serviko_app/features/user/booking/domain/repositories/booking_repository.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/create_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_available_slots_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_bookings_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/review_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_booking_detail_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_customer_bookings_usecase.dart';
import 'package:serviko_app/features/user/payment/data/datasources/payment_remote_datasource.dart';
import 'package:serviko_app/features/user/payment/data/repositories/payment_repository_impl.dart';
import 'package:serviko_app/features/user/payment/domain/repositories/payment_repository.dart';
import 'package:serviko_app/features/user/payment/domain/usecases/create_payment_order_usecase.dart';
import 'package:serviko_app/features/user/payment/domain/usecases/verify_payment_usecase.dart';

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
  late final CreateBookingUseCase createBookingUseCase;
  late final GetProviderBookingsUseCase getProviderBookingsUseCase;
  late final ReviewBookingUseCase reviewBookingUseCase;
  late final GetBookingDetailUseCase getBookingDetailUseCase;
  late final CancelBookingUseCase cancelBookingUseCase;
  late final GetCustomerBookingsUseCase getCustomerBookingsUseCase;

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
    // Core
    apiClient = ApiClient();
    networkInfo = NetworkInfoImpl(Connectivity());
    locationService = LocationService();

    // Communication
    zegoRemoteDataSource = ZegoRemoteDataSourceImpl(apiClient: apiClient);
    communicationRepository = CommunicationRepositoryImpl(
      remoteDataSource: zegoRemoteDataSource,
      networkInfo: networkInfo,
    );
    getProviderDirectoryUseCase = GetProviderDirectoryUseCase(
      communicationRepository,
    );
    zegoTokenManager = ZegoTokenManager(communicationRepository);
    zegoService = ZegoService(tokenManager: zegoTokenManager);

    // Auth - Data
    authLocalDataSource = AuthLocalDataSourceImpl();
    authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);
    authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
    );

    // Auth - Use Cases
    signInUseCase = SignInUseCase(authRepository);
    signUpUseCase = SignUpUseCase(authRepository);
    googleSignInUseCase = GoogleSignInUseCase(authRepository);
    forgotPasswordUseCase = ForgotPasswordUseCase(authRepository);
    checkRecoveryOptionsUseCase = CheckRecoveryOptionsUseCase(authRepository);
    startPhoneResetOtpUseCase = StartPhoneResetOtpUseCase(authRepository);
    verifyPhoneResetOtpUseCase = VerifyPhoneResetOtpUseCase(authRepository);
    resetPasswordWithPhoneOtpUseCase = ResetPasswordWithPhoneOtpUseCase(
      authRepository,
    );
    signOutUseCase = SignOutUseCase(authRepository);
    getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    updateFirebaseDisplayNameUseCase = UpdateFirebaseDisplayNameUseCase(
      authRepository,
    );

    // Profile - Data
    profileLocalDataSource = ProfileLocalDataSourceImpl();
    profileRemoteDataSource = ProfileRemoteDataSourceImpl(apiClient: apiClient);
    userProfileRepository = UserUserProfileRepositoryImpl(
      remoteDataSource: profileRemoteDataSource,
      localDataSource: profileLocalDataSource,
      networkInfo: networkInfo,
    );

    // Profile - Use Cases
    createUserProfileUseCase = CreateUserProfileUseCase(userProfileRepository);
    getMyProfileUseCase = GetMyProfileUseCase(userProfileRepository);
    getCachedProfileUseCase = GetCachedProfileUseCase(userProfileRepository);
    updateProfileUseCase = UpdateProfileUseCase(userProfileRepository);
    uploadProfileImageUseCase = UploadProfileImageUseCase(
      userProfileRepository,
    );
    deleteProfileImageUseCase = DeleteProfileImageUseCase(
      userProfileRepository,
    );

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

    // User Category
    categoryRemoteDataSource = CategoryRemoteDataSourceImpl(
      apiClient: apiClient,
    );
    categoryRepository = CategoryRepositoryImpl(
      remoteDataSource: categoryRemoteDataSource,
      networkInfo: networkInfo,
    );
    userGetCategoriesUseCase = user_category.GetCategoriesUseCase(
      categoryRepository,
    );

    // User Service
    serviceRemoteDataSource = ServiceRemoteDataSourceImpl(apiClient: apiClient);
    serviceRepository = ServiceRepositoryImpl(
      remoteDataSource: serviceRemoteDataSource,
      networkInfo: networkInfo,
    );
    getPopularServicesUseCase = GetPopularServicesUseCase(serviceRepository);
    getServiceDetailUseCase = GetServiceDetailUseCase(serviceRepository);

    // Search
    searchRemoteDataSource = SearchRemoteDataSourceImpl(apiClient: apiClient);
    searchRepository = SearchRepositoryImpl(
      remoteDataSource: searchRemoteDataSource,
      networkInfo: networkInfo,
    );
    searchServicesUseCase = SearchServicesUseCase(searchRepository);

    // Booking
    bookingRemoteDataSource = BookingRemoteDataSourceImpl(apiClient: apiClient);
    bookingRepository = BookingRepositoryImpl(
      remoteDataSource: bookingRemoteDataSource,
      networkInfo: networkInfo,
    );
    getAvailableSlotsUseCase = GetAvailableSlotsUseCase(bookingRepository);
    createBookingUseCase = CreateBookingUseCase(bookingRepository);
    getProviderBookingsUseCase = GetProviderBookingsUseCase(bookingRepository);
    reviewBookingUseCase = ReviewBookingUseCase(bookingRepository);
    getBookingDetailUseCase = GetBookingDetailUseCase(bookingRepository);
    cancelBookingUseCase = CancelBookingUseCase(bookingRepository);
    getCustomerBookingsUseCase = GetCustomerBookingsUseCase(bookingRepository);

    // Payment
    paymentRemoteDataSource = PaymentRemoteDataSourceImpl(apiClient: apiClient);
    paymentRepository = PaymentRepositoryImpl(
      remoteDataSource: paymentRemoteDataSource,
      networkInfo: networkInfo,
    );
    createPaymentOrderUseCase = CreatePaymentOrderUseCase(paymentRepository);
    verifyPaymentUseCase = VerifyPaymentUseCase(paymentRepository);

    // Support
    supportRemoteDataSource = SupportRemoteDataSourceImpl(apiClient: apiClient);
    supportRepository = SupportRepositoryImpl(
      remoteDataSource: supportRemoteDataSource,
      networkInfo: networkInfo,
    );
    getFAQsUseCase = GetFAQsUseCase(supportRepository);
    getPrivacyPolicyUseCase = GetPrivacyPolicyUseCase(supportRepository);
  }
}
