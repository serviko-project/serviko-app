import 'package:shared_preferences/shared_preferences.dart';

// Manages local auth-related flags
abstract class AuthLocalDataSource {
  Future<bool> isProfileCompleted(String uid);
  Future<void> markProfileCompleted(String uid);
  Future<void> clearProfileCompletion(String uid);

  Future<bool> isOnboardingCompleted();
  Future<void> markOnboardingCompleted();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _profileCompletedPrefix = 'profile_completed_';

  @override
  Future<bool> isProfileCompleted(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_profileCompletedPrefix$uid') ?? false;
  }

  @override
  Future<void> markProfileCompleted(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_profileCompletedPrefix$uid', true);
  }

  @override
  Future<void> clearProfileCompletion(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_profileCompletedPrefix$uid');
  }

  static const _onboardingCompletedKey = 'onboarding_completed';

  @override
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  @override
  Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }
}
