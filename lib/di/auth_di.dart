import 'package:serviko_app/features/user/auth/data/datasources/auth_local_datasource.dart';
import 'package:serviko_app/features/user/auth/data/datasources/auth_remote_datasource.dart';
import 'package:serviko_app/features/user/auth/data/repositories/auth_repository_impl.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/check_recovery_options_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/reset_password_with_phone_otp_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/sign_in_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/sign_out_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/sign_up_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/start_phone_reset_otp_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/update_firebase_display_name_usecase.dart';
import 'package:serviko_app/features/user/auth/domain/usecases/verify_phone_reset_otp_usecase.dart';
import 'package:serviko_app/injection_container.dart';

// Extension to modularize authentication dependencies
extension AuthDI on InjectionContainer {
  void initAuth() {
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
  }
}
