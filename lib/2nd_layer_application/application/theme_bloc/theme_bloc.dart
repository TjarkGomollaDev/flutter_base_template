import 'package:bloc/bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final InterfaceAppSettingsLocalDatasource _appSettingsLocalDatasource;

  ThemeBloc({required InterfaceAppSettingsLocalDatasource appSettingsLocalDatasource})
      : _appSettingsLocalDatasource = appSettingsLocalDatasource,
        super(ThemeState._(useSystemTheme: true, themeMode: true)) {
    on<ThemeEventLoadSettings>(_onLoadSettings);
    on<ThemeEventChangeUseSystemTheme>(_onChangeUseSystemTheme);
    on<ThemeEventChangeThemeMode>(_onChangeThemeMode);
    add(ThemeEventLoadSettings());
  }

  void _onLoadSettings(ThemeEventLoadSettings event, Emitter<ThemeState> emit) async {
    final useSystemTheme = await _appSettingsLocalDatasource.getUseSystemTheme();
    final themeMode = await _appSettingsLocalDatasource.getThemeMode();
    emit(state.copyWith(useSystemTheme: useSystemTheme, themeMode: themeMode));
  }

  void _onChangeUseSystemTheme(ThemeEventChangeUseSystemTheme event, Emitter<ThemeState> emit) {
    _appSettingsLocalDatasource.setUseSystemTheme(value: !state.useSystemTheme);
    emit(state.copyWith(useSystemTheme: !state.useSystemTheme));
  }

  void _onChangeThemeMode(ThemeEventChangeThemeMode event, Emitter<ThemeState> emit) {
    _appSettingsLocalDatasource.setThemeMode(value: !state.themeMode);
    emit(state.copyWith(themeMode: !state.themeMode));
  }
}
