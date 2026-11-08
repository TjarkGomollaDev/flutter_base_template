abstract interface class InterfaceAppSettingsLocalDatasource {
  Future<void> setUseSystemTheme({required bool value});
  Future<bool> getUseSystemTheme();
  Future<void> setThemeMode({required bool value});
  Future<bool> getThemeMode();

  Future<void> setLanguageCode({required String? code});
  Future<String?> getLanguageCode();
}
