// In-memory fake datasource for testing application settings state.
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';

// Provides an in-memory implementation of InterfaceAppSettingsLocalDatasource.
class FakeAppSettingsLocalDatasource
    implements InterfaceAppSettingsLocalDatasource {
  bool useSystemTheme;
  bool isLightMode;
  String? languageCode;

  FakeAppSettingsLocalDatasource({
    this.useSystemTheme = true,
    this.isLightMode = true,
    this.languageCode,
  });

  @override
  Future<void> setUseSystemTheme({required bool value}) async {
    useSystemTheme = value;
  }

  @override
  Future<bool> getUseSystemTheme() async => useSystemTheme;

  @override
  Future<void> setIsLightMode({required bool value}) async {
    isLightMode = value;
  }

  @override
  Future<bool> getIsLightMode() async => isLightMode;

  @override
  Future<void> setLanguageCode({required String? code}) async {
    languageCode = code;
  }

  @override
  Future<String?> getLanguageCode() async => languageCode;
}
