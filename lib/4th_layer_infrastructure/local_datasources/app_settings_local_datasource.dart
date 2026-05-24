// ignore_for_file: constant_identifier_names

import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsLocalDatasource implements InterfaceAppSettingsLocalDatasource {
  final SharedPreferencesAsync _sharedPreferencesAsync;
  static const String _STORAGE_USE_STYSTEM_THEME = 'use_system_theme';
  static const String _STORAGE_THEME_MODE = 'theme_mode';

  AppSettingsLocalDatasource({
    required SharedPreferencesAsync sharedPreferencesAsync,
  }) : _sharedPreferencesAsync = sharedPreferencesAsync;

  // theme
  @override
  Future<void> setUseSystemTheme({required bool value}) async {
    await _sharedPreferencesAsync.setBool(_STORAGE_USE_STYSTEM_THEME, value);
  }

  @override
  Future<bool> getUseSystemTheme() async {
    return await _sharedPreferencesAsync.getBool(_STORAGE_USE_STYSTEM_THEME) ?? true;
  }

  @override
  Future<void> setThemeMode({required bool value}) async {
    await _sharedPreferencesAsync.setBool(_STORAGE_THEME_MODE, value);
  }

  @override
  Future<bool> getThemeMode() async {
    return await _sharedPreferencesAsync.getBool(_STORAGE_THEME_MODE) ?? true;
  }
}
