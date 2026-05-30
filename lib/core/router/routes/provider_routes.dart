import 'package:go_router/go_router.dart';
import '../../../features/provider/main/presentation/pages/provider_main_screen.dart';
import '../../../features/provider/dashboard/presentation/pages/provider_dashboard_screen.dart';
import '../../../features/provider/dashboard/presentation/cubit/provider_dashboard_cubit.dart';
import '../../../features/provider/onboarding/presentation/pages/application_status_screen.dart';
import '../../../features/provider/onboarding/presentation/pages/provider_onboarding_screen.dart';

import '../../../features/provider/profile/presentation/pages/provider_profile_screen.dart';
import '../../../features/provider/profile/presentation/cubit/provider_profile_cubit.dart';
import '../route_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/injection_container.dart';
import '../../../features/provider/profile/presentation/pages/edit_provider_details_screen.dart';
import '../../../features/provider/profile/presentation/pages/edit_provider_services_screen.dart';
import '../../../features/provider/profile/presentation/pages/edit_provider_availability_screen.dart';
import '../../../features/provider/profile/presentation/pages/edit_provider_service_area_screen.dart';
import '../../../features/provider/jobs/presentation/pages/provider_jobs_screen.dart';
import '../../../features/provider/jobs/presentation/cubit/provider_jobs_cubit.dart';
import '../../../features/shared/communication/presentation/cubit/contact_directory_cubit.dart';
import '../../../features/shared/communication/presentation/pages/inbox_screen.dart';
import '../../../features/provider/promo_codes/presentation/pages/provider_promo_codes_screen.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_service.dart';
import '../../../features/provider/earnings/presentation/pages/earnings_page.dart';
import '../../../features/provider/earnings/presentation/pages/transaction_history_screen.dart';

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
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ProviderDashboardCubit(
                    getDashboardStatsUseCase:
                        InjectionContainer.instance.getDashboardStatsUseCase,
                  ),
                ),
                BlocProvider(
                  create: (context) => ProviderJobsCubit(
                    getProviderBookingsUseCase:
                        InjectionContainer.instance.getProviderBookingsUseCase,
                    reviewBookingUseCase:
                        InjectionContainer.instance.reviewBookingUseCase,
                    completeBookingUseCase:
                        InjectionContainer.instance.completeBookingUseCase,
                  ),
                ),
              ],
              child: const ProviderDashboardScreen(),
            ),
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
                completeBookingUseCase:
                    InjectionContainer.instance.completeBookingUseCase,
              ),
              child: const ProviderJobsScreen(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            name: RouteNames.providerEarnings,
            path: RoutePaths.providerEarnings,
            builder: (context, state) => const EarningsPage(),
            routes: [
              GoRoute(
                name: RouteNames.providerTransactionHistory,
                path: RoutePaths.providerTransactionHistory,
                parentNavigatorKey: ZegoService.navigatorKey,
                builder: (context, state) => const TransactionHistoryScreen(),
              ),
            ],
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
            name: RouteNames.providerProfile,
            path: RoutePaths.providerProfile,
            builder: (context, state) => const ProviderProfileScreen(),
            routes: [
              GoRoute(
                name: RouteNames.providerEditDetails,
                path: RoutePaths.providerEditDetails,
                parentNavigatorKey: ZegoService.navigatorKey,
                builder: (context, state) {
                  final profileCubit = state.extra as ProviderProfileCubit;
                  return BlocProvider.value(
                    value: profileCubit,
                    child: const EditProviderDetailsScreen(),
                  );
                },
              ),
              GoRoute(
                name: RouteNames.providerPromoCodes,
                path: RoutePaths.providerPromoCodes,
                parentNavigatorKey: ZegoService.navigatorKey,
                builder: (context, state) => const ProviderPromoCodesScreen(),
              ),
              GoRoute(
                name: RouteNames.providerEditServices,
                path: RoutePaths.providerEditServices,
                parentNavigatorKey: ZegoService.navigatorKey,
                builder: (context, state) {
                  final profileCubit = state.extra as ProviderProfileCubit;
                  return BlocProvider.value(
                    value: profileCubit,
                    child: const EditProviderServicesScreen(),
                  );
                },
              ),
              GoRoute(
                name: RouteNames.providerEditAvailability,
                path: RoutePaths.providerEditAvailability,
                parentNavigatorKey: ZegoService.navigatorKey,
                builder: (context, state) {
                  final profileCubit = state.extra as ProviderProfileCubit;
                  return BlocProvider.value(
                    value: profileCubit,
                    child: const EditProviderAvailabilityScreen(),
                  );
                },
              ),
              GoRoute(
                name: RouteNames.providerEditServiceArea,
                path: RoutePaths.providerEditServiceArea,
                parentNavigatorKey: ZegoService.navigatorKey,
                builder: (context, state) {
                  final profileCubit = state.extra as ProviderProfileCubit;
                  return BlocProvider.value(
                    value: profileCubit,
                    child: const EditProviderServiceAreaScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
