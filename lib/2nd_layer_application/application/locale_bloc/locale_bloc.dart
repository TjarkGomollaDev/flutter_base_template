import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:meta/meta.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final InterfaceAppSettingsLocalDatasource _appSettingsLocalDatasource;

  LocaleBloc({required this._appSettingsLocalDatasource})
    : super(const LocaleState._(locale: null)) {
    on<LocaleEvent>(
      _onEvent,
      transformer: (events, mapper) => events.asyncExpand(mapper),
    );
    add(const LocaleEventLoadSettings());
  }

  Future<void> _onEvent(LocaleEvent event, Emitter<LocaleState> emit) async {
    switch (event) {
      case LocaleEventLoadSettings():
        final languageCode = await _appSettingsLocalDatasource
            .getLanguageCode();
        emit(state.copyWith(locale: () => _localeFromCodeOrNull(languageCode)));
      case LocaleEventChangeLocale():
        await _appSettingsLocalDatasource.setLanguageCode(
          code: event.languageCode,
        );
        emit(
          state.copyWith(
            locale: () => _localeFromCodeOrNull(event.languageCode),
          ),
        );
    }
  }

  Locale? _localeFromCodeOrNull(String? code) {
    if (code == null) return null;
    if (code == 'de') return const Locale('de');
    if (code == 'en') return const Locale('en');
    return null;
  }
}
