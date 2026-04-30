import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/user/auth/presentation/bloc/auth_bloc.dart';
import '../../features/user/role/presentation/cubit/role_cubit.dart';
import 'route_constants.dart';

class RouterRedirection {
  RouterRedirection._();

  static String? handle(
    BuildContext context,
    GoRouterState state,
    AuthBloc authBloc,
    RoleCubit roleCubit,
  ) {
    final authState = authBloc.state;
    final currentPath = state.matchedLocation;

    // Loading State
    if (authState is AuthInitial) {
      return currentPath == RoutePaths.splash ? null : RoutePaths.splash;
    }

    final isAuthenticated = authState is AuthAuthenticated;

    // Unauthenticated user
    if (!isAuthenticated) {
      if (!RoutePaths.publicPaths.contains(currentPath)) {
        return RoutePaths.login;
      }

      if (authState is AuthUnauthenticated) {
        final isOnboardingCompleted = authState.isOnboardingCompleted;

        if (isOnboardingCompleted) {
          if (currentPath == RoutePaths.onboarding ||
              currentPath == RoutePaths.splash) {
            return RoutePaths.login;
          }
        } else {
          if (currentPath != RoutePaths.onboarding) {
            return RoutePaths.onboarding;
          }
        }
      }

      return null;
    }

    // --- Authenticated User Logic ---
    final isNewUser = authState.isNewUser;
    final isOnAuthPage = RoutePaths.authPaths.contains(currentPath);
    final isOnProfileSetupPage = RoutePaths.profileSetupPaths.contains(
      currentPath,
    );

    if (isNewUser) {
      if (!isOnProfileSetupPage) {
        return RoutePaths.fillProfile;
      }
      return null;
    }

    // Existing user
    if (isOnAuthPage ||
        isOnProfileSetupPage ||
        currentPath == RoutePaths.splash) {
      return RoutePaths.home;
    }

    // --- Role-based redirect for users ---
    final roleState = roleCubit.state;

    if (RoutePaths.isProviderRoute(currentPath) &&
        !roleState.canSwitchToProvider) {
      return RoutePaths.home;
    }

    if (roleState.isProvider && RoutePaths.isCustomerShellRoute(currentPath)) {
      return RoutePaths.providerDashboard;
    }

    if (roleState.isCustomer && RoutePaths.isProviderRoute(currentPath)) {
      return RoutePaths.home;
    }

    return null;
  }
}
