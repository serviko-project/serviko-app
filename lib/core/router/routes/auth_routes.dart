import 'package:go_router/go_router.dart';
import '../../../features/user/auth/presentation/pages/choose_reset_method_screen.dart';
import '../../../features/user/auth/presentation/pages/create_new_password_screen.dart';
import '../../../features/user/auth/presentation/pages/forgot_password_screen.dart';
import '../../../features/user/auth/presentation/pages/otp_verification_screen.dart';
import '../../../features/user/auth/presentation/pages/reset_success_screen.dart';
import '../../../features/user/auth/presentation/pages/sign_in_screen.dart';
import '../../../features/user/auth/presentation/pages/sign_up_screen.dart';
import '../../../features/user/auth/presentation/models/password_recovery_flow_args.dart';
import '../route_constants.dart';

List<RouteBase> authRoutes = [
  GoRoute(
    name: RouteNames.login,
    path: RoutePaths.login,
    builder: (context, state) => const SignInScreen(),
  ),
  GoRoute(
    name: RouteNames.register,
    path: RoutePaths.register,
    builder: (context, state) => const SignUpScreen(),
  ),
  GoRoute(
    name: RouteNames.otpVerification,
    path: RoutePaths.otpVerification,
    builder: (context, state) =>
        OtpVerificationScreen(args: state.extra as OtpVerificationArgs),
  ),
  GoRoute(
    name: RouteNames.forgotPassword,
    path: RoutePaths.forgotPassword,
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    name: RouteNames.chooseResetMethod,
    path: RoutePaths.chooseResetMethod,
    builder: (context, state) =>
        ChooseResetMethodScreen(args: state.extra as ChooseResetMethodArgs),
  ),
  GoRoute(
    name: RouteNames.createNewPassword,
    path: RoutePaths.createNewPassword,
    builder: (context, state) =>
        CreateNewPasswordScreen(args: state.extra as CreateNewPasswordArgs),
  ),
  GoRoute(
    name: RouteNames.resetSuccess,
    path: RoutePaths.resetSuccess,
    builder: (context, state) => const ResetSuccessScreen(),
  ),
];
