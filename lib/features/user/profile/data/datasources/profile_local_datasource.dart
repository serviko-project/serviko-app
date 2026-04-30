import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serviko_app/features/user/profile/data/models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheProfile(UserProfileModel profileToCache);
  Future<UserProfileModel?> getLastProfile();
  Future<void> clearCache();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const cachedProfile = 'CACHED_PROFILE';

  @override
  Future<void> cacheProfile(UserProfileModel profileToCache) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cachedProfile, json.encode(profileToCache.toJson()));
  }

  @override
  Future<UserProfileModel?> getLastProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(cachedProfile);
    if (jsonString != null) {
      return UserProfileModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cachedProfile);
  }
}
