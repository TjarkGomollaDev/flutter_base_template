abstract class InterfaceAppSettingsLocalDatasource {
  // theme
  Future<void> setUseSystemTheme({required bool value});
  Future<bool> getUseSystemTheme();
  Future<void> setThemeMode({required bool value});
  Future<bool> getThemeMode();

  // locale
  Future<void> setLanguageCode({required String? code});
  Future<String?> getLanguageCode();
}
