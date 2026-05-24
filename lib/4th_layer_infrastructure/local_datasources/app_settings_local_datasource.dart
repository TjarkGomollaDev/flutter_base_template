// ignore_for_file: constant_identifier_names

import 'package:mark_lxxxv/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsLocalDatasource implements InterfaceAppSettingsLocalDatasource {
  final SharedPreferences _sharedPreferences;
  static const String _STORAGE_DEVICE_OPEN_FIRST_TIME = 'device_first_open';
  static const String _STORAGE_USE_STYSTEM_THEME = 'use_system_theme';
  static const String _STORAGE_THEME_MODE = 'theme_mode';
  static const String _STORAGE_APPLICATION_INDEX = 'app_index';
  static const String _STORAGE_RECENT_SEARCHES = 'recent_searches';

  AppSettingsLocalDatasource({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  // onboarding
  @override
  Future<void> setDeviceOpenFirstTime({required bool value}) async {
    await _sharedPreferences.setBool(_STORAGE_DEVICE_OPEN_FIRST_TIME, value);
  }

  @override
  bool getDeviceOpenFirstTime() {
    return _sharedPreferences.getBool(_STORAGE_DEVICE_OPEN_FIRST_TIME) ?? true;
  }

  // theme
  @override
  Future<void> setUseSystemTheme({required bool value}) async {
    await _sharedPreferences.setBool(_STORAGE_USE_STYSTEM_THEME, value);
  }

  @override
  bool getUseSystemTheme() {
    return _sharedPreferences.getBool(_STORAGE_USE_STYSTEM_THEME) ?? true;
  }

  @override
  Future<void> setThemeMode({required bool value}) async {
    await _sharedPreferences.setBool(_STORAGE_THEME_MODE, value);
  }

  @override
  bool getThemeMode() {
    return _sharedPreferences.getBool(_STORAGE_THEME_MODE) ?? true;
  }

  // application index
  @override
  Future<void> setApplicationIndex({required int value}) async {
    await _sharedPreferences.setInt(_STORAGE_APPLICATION_INDEX, value);
  }

  @override
  int getApplicationIndex() {
    return _sharedPreferences.getInt(_STORAGE_APPLICATION_INDEX) ?? 0;
  }

  @override
  Future<void> resetApplicationIndex() async {
    await _sharedPreferences.remove(_STORAGE_APPLICATION_INDEX);
  }

  // recent searches
  @override
  Future<void> setRecentSearches({required List<String> recentSearches}) async {
    await _sharedPreferences.setStringList(_STORAGE_RECENT_SEARCHES, recentSearches);
  }

  @override
  List<String> getRecentSearches() {
    return _sharedPreferences.getStringList(_STORAGE_RECENT_SEARCHES) ?? [];
  }

  @override
  Future<void> resetRecentSearches() async {
    await _sharedPreferences.remove(_STORAGE_RECENT_SEARCHES);
  }
}
