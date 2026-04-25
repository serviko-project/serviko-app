import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/core/network/network_info.dart';
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
import 'package:serviko_app/features/user/profile/data/datasources/profile_remote_datasource.dart';
import 'package:serviko_app/features/user/profile/data/repositories/profile_repository_impl.dart';
import 'package:serviko_app/features/user/profile/domain/repositories/profile_repository.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/create_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/update_profile_usecase.dart';

class InjectionContainer {
  InjectionContainer._();

  static final InjectionContainer _instance = InjectionContainer._();
  static InjectionContainer get instance => _instance;

  // Core
  late final ApiClient apiClient;
  late final NetworkInfo networkInfo;

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

  // Profile
  late final ProfileRemoteDataSource profileRemoteDataSource;
  late final UserProfileRepository userProfileRepository;
  late final CreateUserProfileUseCase createUserProfileUseCase;
  late final GetMyProfileUseCase getMyProfileUseCase;
  late final UpdateProfileUseCase updateProfileUseCase;

  // Initialise
  Future<void> init() async {
    // Core
    apiClient = ApiClient();
    networkInfo = NetworkInfoImpl(InternetConnection());

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

    // Profile - Data
    profileRemoteDataSource = ProfileRemoteDataSourceImpl(apiClient: apiClient);
    userProfileRepository = UserUserProfileRepositoryImpl(
      remoteDataSource: profileRemoteDataSource,
      networkInfo: networkInfo,
    );

    // Profile - Use Cases
    createUserProfileUseCase = CreateUserProfileUseCase(userProfileRepository);
    getMyProfileUseCase = GetMyProfileUseCase(userProfileRepository);
    updateProfileUseCase = UpdateProfileUseCase(userProfileRepository);
  }
}
