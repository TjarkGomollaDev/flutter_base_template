import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsLocalDatasource
    implements InterfaceAppSettingsLocalDatasource {
  final SharedPreferencesAsync _sharedPreferencesAsync;
  static const String _storageUseSystemTheme = 'use_system_theme';
  static const String _storageThemeMode = 'theme_mode';
  static const String _storageLanguageCode = 'language_code';

  AppSettingsLocalDatasource({required this._sharedPreferencesAsync});

  @override
  Future<void> setUseSystemTheme({required bool value}) async {
    await _sharedPreferencesAsync.setBool(_storageUseSystemTheme, value);
  }

  @override
  Future<bool> getUseSystemTheme() async {
    return (await _sharedPreferencesAsync.getBool(_storageUseSystemTheme)) ??
        true;
  }

  @override
  Future<void> setThemeMode({required bool value}) async {
    await _sharedPreferencesAsync.setBool(_storageThemeMode, value);
  }

  @override
  Future<bool> getThemeMode() async {
    return (await _sharedPreferencesAsync.getBool(_storageThemeMode)) ?? true;
  }

  @override
  Future<void> setLanguageCode({required String? code}) async {
    if (code == null) {
      await _sharedPreferencesAsync.remove(_storageLanguageCode);
    } else {
      await _sharedPreferencesAsync.setString(_storageLanguageCode, code);
    }
  }

  @override
  Future<String?> getLanguageCode() {
    return _sharedPreferencesAsync.getString(_storageLanguageCode);
  }
}
