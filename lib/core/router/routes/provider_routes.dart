import 'package:go_router/go_router.dart';
import '../../../features/provider/main/presentation/pages/provider_main_screen.dart';
import '../../../features/provider/onboarding/presentation/pages/application_status_screen.dart';
import '../../../features/provider/onboarding/presentation/pages/provider_onboarding_screen.dart';
import '../../../features/provider/profile/presentation/pages/provider_profile_screen.dart';
import '../../../features/provider/profile/presentation/cubit/provider_profile_cubit.dart';
import '../../widgets/placeholder_screen.dart';
import '../route_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/injection_container.dart';
import '../../../features/provider/profile/presentation/pages/edit_provider_details_screen.dart';
import '../../../features/provider/jobs/presentation/pages/provider_jobs_screen.dart';
import '../../../features/provider/jobs/presentation/cubit/provider_jobs_cubit.dart';
import '../../../features/shared/communication/presentation/cubit/contact_directory_cubit.dart';
import '../../../features/shared/communication/presentation/pages/inbox_screen.dart';

List<RouteBase> providerRoutes = [
  // ---- Provider Onboarding ----
  GoRoute(
    name: RouteNames.providerOnboarding,
    path: RoutePaths.providerOnboarding,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final isReapplication = extra?['isReapplication'] == true;
      return ProviderOnboardingScreen(isReapplication: isReapplication);
    },
  ),

  // ---- Provider Application Status ----
  GoRoute(
    name: RouteNames.providerApplicationStatus,
    path: RoutePaths.providerApplicationStatus,
    builder: (context, state) => const ApplicationStatusScreen(),
  ),

  // ---- Provider Shell ----
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return BlocProvider(
        lazy: false,
        create: (context) => ProviderProfileCubit(
          getMyProviderProfileUseCase:
              InjectionContainer.instance.getMyProviderProfileUseCase,
        )..fetchProviderProfile(),
        child: ProviderMainScreen(navigationShell: navigationShell),
      );
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            name: RouteNames.providerDashboard,
            path: RoutePaths.providerDashboard,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Provider Dashboard'),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            name: RouteNames.providerJobs,
            path: RoutePaths.providerJobs,
            builder: (context, state) => BlocProvider(
              create: (context) => ProviderJobsCubit(
                getProviderBookingsUseCase:
                    InjectionContainer.instance.getProviderBookingsUseCase,
                reviewBookingUseCase:
                    InjectionContainer.instance.reviewBookingUseCase,
              ),
              child: const ProviderJobsScreen(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            name: RouteNames.providerInbox,
            path: RoutePaths.providerInbox,
            builder: (context, state) => BlocProvider(
              create: (context) => ContactDirectoryCubit(
                getProviderDirectoryUseCase:
                    InjectionContainer.instance.getProviderDirectoryUseCase,
              ),
              child: const InboxScreen(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            name: RouteNames.providerEarnings,
            path: RoutePaths.providerEarnings,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Earnings'),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            name: RouteNames.providerProfile,
            path: RoutePaths.providerProfile,
            builder: (context, state) => const ProviderProfileScreen(),
            routes: [
              GoRoute(
                name: RouteNames.providerEditDetails,
                path: RoutePaths.providerEditDetails,
                builder: (context, state) => const EditProviderDetailsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
