import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/user/auth/presentation/pages/address_screen.dart';
import '../../../features/user/auth/presentation/pages/congratulations_screen.dart';
import '../../../features/user/auth/presentation/pages/fill_profile_screen.dart';
import '../../../features/user/auth/presentation/pages/splash_screen.dart';
import '../../../features/user/onboarding/presentation/pages/onboarding_screen.dart';
import '../../../features/user/profile/presentation/pages/edit_profile_screen.dart';
import '../../../features/user/bookmarks/presentation/pages/bookmarks_screen.dart';
import '../../../features/user/search/presentation/pages/search_screen.dart';
import '../../../features/user/category/presentation/pages/all_categories_screen.dart';
import '../../../features/user/category/presentation/pages/category_details_screen.dart';
import '../../../features/user/home/presentation/pages/service_detail_screen.dart';
import '../../../features/user/booking/domain/entities/booking_init_data.dart';
import '../../../features/user/booking/domain/entities/booking_request_payload.dart';
import '../../../features/user/booking/presentation/pages/booking_details_screen.dart';
import '../../../features/user/booking/presentation/pages/booking_location_screen.dart';
import '../../../features/user/booking/presentation/pages/promo_selection_screen.dart';
import '../../../features/user/booking/presentation/pages/booking_summary_screen.dart';
import '../../../features/user/booking/presentation/pages/booking_success_screen.dart';
import '../../../features/user/booking/presentation/pages/view_booking_screen.dart';
import '../../../features/shared/support/presentation/pages/privacy_policy_screen.dart';
import '../../../features/shared/support/presentation/pages/help_center_screen.dart';
import '../route_constants.dart';

List<RouteBase> miscRoutes = [
  // ---- Splash ----
  GoRoute(
    name: RouteNames.splash,
    path: RoutePaths.splash,
    builder: (context, state) => const SplashScreen(),
  ),

  // ---- Onboarding ----
  GoRoute(
    name: RouteNames.onboarding,
    path: RoutePaths.onboarding,
    builder: (context, state) => const OnboardingScreen(),
  ),

  // ---- Profile Setup ----
  GoRoute(
    name: RouteNames.fillProfile,
    path: RoutePaths.fillProfile,
    builder: (context, state) => const FillProfileScreen(),
  ),
  GoRoute(
    name: RouteNames.address,
    path: RoutePaths.address,
    builder: (context, state) => const AddressScreen(),
  ),
  GoRoute(
    name: RouteNames.congratulations,
    path: RoutePaths.congratulations,
    builder: (context, state) => const CongratulationsScreen(),
  ),

  GoRoute(
    name: RouteNames.editProfile,
    path: RoutePaths.editProfile,
    builder: (context, state) => const EditProfileScreen(),
  ),
  GoRoute(
    name: RouteNames.search,
    path: RoutePaths.search,
    builder: (context, state) {
      final openFilter = state.extra as bool? ?? false;
      return SearchScreen(openFilter: openFilter);
    },
  ),
  GoRoute(
    name: RouteNames.bookmarks,
    path: RoutePaths.bookmarks,
    builder: (context, state) => const BookmarksScreen(),
  ),
  GoRoute(
    name: RouteNames.allCategories,
    path: RoutePaths.allCategories,
    builder: (context, state) => const AllCategoriesScreen(),
  ),
  GoRoute(
    name: RouteNames.categoryDetails,
    path: RoutePaths.categoryDetails,
    builder: (context, state) {
      final Map<String, dynamic> extra =
          state.extra as Map<String, dynamic>? ?? {};
      final categoryId = extra['id'] as String? ?? '';
      final categoryName = extra['name'] as String? ?? 'Category Details';
      return CategoryDetailsScreen(
        categoryId: categoryId,
        categoryName: categoryName,
      );
    },
  ),
  GoRoute(
    name: RouteNames.serviceDetails,
    path: RoutePaths.serviceDetails,
    builder: (context, state) {
      final serviceId = state.extra as String? ?? "";
      return ServiceDetailScreen(serviceId: serviceId);
    },
  ),
  GoRoute(
    name: RouteNames.bookingDetails,
    path: RoutePaths.bookingDetails,
    builder: (context, state) {
      final initData = state.extra as BookingInitData?;
      if (initData == null) {
        return Scaffold(body: Center(child: Text('Missing booking data')));
      }
      return BookingDetailsScreen(initData: initData);
    },
  ),
  GoRoute(
    name: RouteNames.promoSelection,
    path: RoutePaths.promoSelection,
    builder: (context, state) => const PromoSelectionScreen(),
  ),
  GoRoute(
    name: RouteNames.bookingLocation,
    path: RoutePaths.bookingLocation,
    builder: (context, state) {
      final payload = state.extra as BookingRequestPayload?;
      if (payload == null) {
        return const Scaffold(
          body: Center(child: Text('Missing booking request data')),
        );
      }
      return BookingLocationScreen(payload: payload);
    },
  ),
  GoRoute(
    name: RouteNames.bookingSummary,
    path: RoutePaths.bookingSummary,
    builder: (context, state) {
      final payload = state.extra as BookingRequestPayload?;
      if (payload == null) {
        return const Scaffold(
          body: Center(child: Text('Missing booking summary data')),
        );
      }
      return BookingSummaryScreen(payload: payload);
    },
  ),
  GoRoute(
    name: RouteNames.bookingSuccess,
    path: RoutePaths.bookingSuccess,
    builder: (context, state) => BookingSuccessScreen(),
  ),
  GoRoute(
    name: RouteNames.viewBooking,
    path: RoutePaths.viewBooking,
    builder: (context, state) {
      final bookingId = state.pathParameters['id'] ?? '';
      return ViewBookingScreen(bookingId: bookingId);
    },
  ),
  GoRoute(
    name: RouteNames.privacyPolicy,
    path: RoutePaths.privacyPolicy,
    builder: (context, state) => const PrivacyPolicyScreen(),
  ),
  GoRoute(
    name: RouteNames.helpCenter,
    path: RoutePaths.helpCenter,
    builder: (context, state) => const HelpCenterScreen(),
  ),
];
