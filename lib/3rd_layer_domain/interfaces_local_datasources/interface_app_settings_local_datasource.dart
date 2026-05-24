abstract class InterfaceAppSettingsLocalDatasource {
  // onboarding
  Future<void> setDeviceOpenFirstTime({required bool value});
  bool getDeviceOpenFirstTime();

  // theme
  Future<void> setUseSystemTheme({required bool value});
  bool getUseSystemTheme();
  Future<void> setThemeMode({required bool value});
  bool getThemeMode();

  // application index
  Future<void> setApplicationIndex({required int value});
  int getApplicationIndex();
  Future<void> resetApplicationIndex();

  // recent searches
  Future<void> setRecentSearches({required List<String> recentSearches});
  List<String> getRecentSearches();
  Future<void> resetRecentSearches();
}
