import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/go_router_refresh_stream.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_service.dart';
import 'package:serviko_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
import 'route_constants.dart';
import 'router_redirection.dart';
import 'routes/auth_routes.dart';
import 'routes/customer_routes.dart';
import 'routes/provider_routes.dart';
import 'routes/misc_routes.dart';

class AppRouter {
  AppRouter._();

  // ---- Route Names ----
  static const String splash = RouteNames.splash;
  static const String onboarding = RouteNames.onboarding;
  static const String login = RouteNames.login;
  static const String register = RouteNames.register;
  static const String otpVerification = RouteNames.otpVerification;
  static const String forgotPassword = RouteNames.forgotPassword;
  static const String chooseResetMethod = RouteNames.chooseResetMethod;
  static const String createNewPassword = RouteNames.createNewPassword;
  static const String resetSuccess = RouteNames.resetSuccess;
  static const String fillProfile = RouteNames.fillProfile;
  static const String address = RouteNames.address;
  static const String congratulations = RouteNames.congratulations;
  static const String home = RouteNames.home;
  static const String booking = RouteNames.booking;
  static const String calendar = RouteNames.calendar;
  static const String inbox = RouteNames.inbox;
  static const String profile = RouteNames.profile;
  static const String editProfile = RouteNames.editProfile;
  static const String search = RouteNames.search;
  static const String bookmarks = RouteNames.bookmarks;
  static const String serviceDetails = RouteNames.serviceDetails;

  static const String providerOnboarding = RouteNames.providerOnboarding;
  static const String providerApplicationStatus =
      RouteNames.providerApplicationStatus;
  static const String providerDashboard = RouteNames.providerDashboard;
  static const String providerJobs = RouteNames.providerJobs;
  static const String providerInbox = RouteNames.providerInbox;
  static const String providerEarnings = RouteNames.providerEarnings;
  static const String providerProfile = RouteNames.providerProfile;

  // Router configuration with auth + role-based redirection
  static GoRouter router(AuthBloc authBloc, RoleCubit roleCubit) => GoRouter(
    navigatorKey: ZegoService.navigatorKey,
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream([
      authBloc.stream,
      roleCubit.stream,
    ]),
    redirect: (context, state) =>
        RouterRedirection.handle(context, state, authBloc, roleCubit),
    routes: [...miscRoutes, ...authRoutes, customerRoutes, ...providerRoutes],
  );
}
