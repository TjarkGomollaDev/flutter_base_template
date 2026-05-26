import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final InterfaceAppSettingsLocalDatasource _appSettingsLocalDatasource;

  LocaleBloc(
      {required InterfaceAppSettingsLocalDatasource appSettingsLocalDatasource})
      : _appSettingsLocalDatasource = appSettingsLocalDatasource,
        super(const LocaleState._(locale: null)) {
    on<LocaleEventLoadSettings>(_onLoadSettings);
    on<LocaleEventChangeLocale>(_onChangeLocale);
    add(LocaleEventLoadSettings());
  }

  void _onLoadSettings(
      LocaleEventLoadSettings event, Emitter<LocaleState> emit) async {
    final languageCode = await _appSettingsLocalDatasource.getLanguageCode();
    emit(state.copyWith(locale: () => _localeFromCodeOrNull(languageCode)));
  }

  void _onChangeLocale(
      LocaleEventChangeLocale event, Emitter<LocaleState> emit) async {
    await _appSettingsLocalDatasource.setLanguageCode(code: event.languageCode);
    emit(state.copyWith(
        locale: () => _localeFromCodeOrNull(event.languageCode)));
  }

  Locale? _localeFromCodeOrNull(String? code) {
    if (code == null) return null;
    if (code == 'de') return const Locale('de');
    if (code == 'en') return const Locale('en');
    // fallback to system
    return null;
  }
}
