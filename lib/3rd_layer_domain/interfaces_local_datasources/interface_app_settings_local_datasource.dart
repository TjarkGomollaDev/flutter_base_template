abstract interface class InterfaceAppSettingsLocalDatasource {
  Future<void> setUseSystemTheme({required bool value});
  Future<bool> getUseSystemTheme();
  Future<void> setIsLightMode({required bool value});
  Future<bool> getIsLightMode();

  Future<void> setLanguageCode({required String? code});
  Future<String?> getLanguageCode();
}
