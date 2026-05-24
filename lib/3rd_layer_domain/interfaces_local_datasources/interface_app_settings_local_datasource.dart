abstract class InterfaceAppSettingsLocalDatasource {
  // theme
  Future<void> setUseSystemTheme({required bool value});
  bool getUseSystemTheme();
  Future<void> setThemeMode({required bool value});
  bool getThemeMode();

  // application index
  Future<void> setApplicationIndex({required int value});
  int getApplicationIndex();
  Future<void> resetApplicationIndex();
}
