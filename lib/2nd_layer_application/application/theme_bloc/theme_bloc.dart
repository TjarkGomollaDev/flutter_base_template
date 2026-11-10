import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final InterfaceAppSettingsLocalDatasource _appSettingsLocalDatasource;

  ThemeBloc({required this._appSettingsLocalDatasource})
    : super(const ThemeState._(useSystemTheme: true, isLightMode: true)) {
    on<ThemeEvent>(
      _onEvent,
      transformer: (events, mapper) => events.asyncExpand(mapper),
    );
    add(const ThemeEventLoadSettings());
  }

  Future<void> _onEvent(ThemeEvent event, Emitter<ThemeState> emit) async {
    switch (event) {
      case ThemeEventLoadSettings():
        final useSystemTheme = await _appSettingsLocalDatasource
            .getUseSystemTheme();
        final isLightMode = await _appSettingsLocalDatasource.getIsLightMode();
        emit(
          state.copyWith(
            useSystemTheme: useSystemTheme,
            isLightMode: isLightMode,
          ),
        );
      case ThemeEventChangeUseSystemTheme():
        final nextUseSystemTheme = !state.useSystemTheme;
        await _appSettingsLocalDatasource.setUseSystemTheme(
          value: nextUseSystemTheme,
        );
        emit(state.copyWith(useSystemTheme: nextUseSystemTheme));
      case ThemeEventChangeThemeMode():
        final nextIsLightMode = !state.isLightMode;
        await _appSettingsLocalDatasource.setIsLightMode(
          value: nextIsLightMode,
        );
        emit(state.copyWith(isLightMode: nextIsLightMode));
    }
  }
}
