import 'package:shared_preferences/shared_preferences.dart';

abstract class SearchLocalDataSource {
  Future<List<String>> getRecentSearches();
  Future<void> saveRecentSearch(String query);
  Future<void> removeRecentSearch(String query);
  Future<void> clearRecentSearches();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  static const _keyRecentSearches = 'recent_searches';
  static const _maxRecentSearches = 10;

  @override
  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyRecentSearches) ?? [];
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyRecentSearches) ?? [];
    list.remove(query);
    list.insert(0, query);
    if (list.length > _maxRecentSearches) {
      list.removeLast();
    }
    await prefs.setStringList(_keyRecentSearches, list);
  }

  @override
  Future<void> removeRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyRecentSearches) ?? [];
    list.remove(query);
    await prefs.setStringList(_keyRecentSearches, list);
  }

  @override
  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRecentSearches);
  }
}
