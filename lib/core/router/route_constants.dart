class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String otpVerification = 'otpVerification';
  static const String forgotPassword = 'forgotPassword';
  static const String chooseResetMethod = 'chooseResetMethod';
  static const String createNewPassword = 'createNewPassword';
  static const String resetSuccess = 'resetSuccess';
  static const String fillProfile = 'fillProfile';
  static const String address = 'address';
  static const String congratulations = 'congratulations';
  static const String home = 'home';
  static const String booking = 'booking';
  static const String calendar = 'calendar';
  static const String inbox = 'inbox';
  static const String profile = 'profile';
  static const String editProfile = 'editProfile';
  static const String search = 'search';
  static const String bookmarks = 'bookmarks';
  static const String allCategories = 'allCategories';
  static const String categoryDetails = 'categoryDetails';
  static const String serviceDetails = 'serviceDetails';
  static const String bookingDetails = 'bookingDetails';
  static const String promoSelection = 'promoSelection';
  static const String bookingLocation = 'bookingLocation';
  static const String bookingSummary = 'bookingSummary';
  static const String bookingSuccess = 'bookingSuccess';
  static const String viewBooking = 'viewBooking';

  // Provider route names
  static const String providerOnboarding = 'providerOnboarding';
  static const String providerApplicationStatus = 'providerApplicationStatus';
  static const String providerDashboard = 'providerDashboard';
  static const String providerJobs = 'providerJobs';
  static const String providerInbox = 'providerInbox';
  static const String providerEarnings = 'providerEarnings';
  static const String providerProfile = 'providerProfile';
  static const String providerEditDetails = 'providerEditDetails';
}

class RoutePaths {
  RoutePaths._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String chooseResetMethod = '/choose-reset-method';
  static const String createNewPassword = '/create-new-password';
  static const String resetSuccess = '/reset-success';
  static const String fillProfile = '/fill-profile';
  static const String address = '/address';
  static const String congratulations = '/congratulations';
  static const String home = '/home';
  static const String booking = '/booking';
  static const String calendar = '/calendar';
  static const String inbox = '/inbox';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String search = '/search';
  static const String bookmarks = '/bookmarks';
  static const String allCategories = '/all-categories';
  static const String categoryDetails = '/category-details';
  static const String serviceDetails = '/service-details';
  static const String bookingDetails = '/booking-details';
  static const String promoSelection = '/promo-selection';
  static const String bookingLocation = '/booking-location';
  static const String bookingSummary = '/booking-summary';
  static const String bookingSuccess = '/booking-success';
  static const String viewBooking = '/view-booking/:id';

  // Provider paths
  static const String providerOnboarding = '/provider/onboarding';
  static const String providerApplicationStatus =
      '/provider/application-status';
  static const String providerDashboard = '/provider/dashboard';
  static const String providerJobs = '/provider/jobs';
  static const String providerInbox = '/provider/inbox';
  static const String providerEarnings = '/provider/earnings';
  static const String providerProfile = '/provider/profile';
  static const String providerEditDetails = '/provider/profile/edit';

  // Auth-related paths
  static final Set<String> authPaths = {onboarding, login, register};

  // Paths that anyone can access without authentication
  static final Set<String> publicPaths = {
    splash,
    onboarding,
    login,
    register,
    forgotPassword,
    chooseResetMethod,
    otpVerification,
    createNewPassword,
    resetSuccess,
  };

  // Paths used for profile setup
  static final Set<String> profileSetupPaths = {
    fillProfile,
    address,
    congratulations,
  };

  // Customer Bottom Navigation paths
  static final Set<String> customerShellPaths = {
    home,
    booking,
    calendar,
    inbox,
    profile,
  };

  // Provider Bottom Navigation paths
  static final Set<String> providerShellPaths = {
    providerDashboard,
    providerJobs,
    providerInbox,
    providerEarnings,
    providerProfile,
  };

  static bool isProviderRoute(String path) =>
      path != providerOnboarding &&
      path != providerApplicationStatus &&
      (providerShellPaths.contains(path) || path.startsWith('/provider'));

  static bool isCustomerShellRoute(String path) =>
      customerShellPaths.contains(path);
}
