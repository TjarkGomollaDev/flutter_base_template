import 'package:bloc/bloc.dart';
import 'package:mark_lxxxv/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final InterfaceAppSettingsLocalDatasource _appSettingsLocalDatasource;

  ThemeBloc({required InterfaceAppSettingsLocalDatasource appSettingsLocalDatasource})
      : _appSettingsLocalDatasource = appSettingsLocalDatasource,
        super(ThemeState._(
            useSystemTheme: appSettingsLocalDatasource.getUseSystemTheme(),
            themeMode: appSettingsLocalDatasource.getThemeMode())) {
    on<ThemeEventChangeUseSystemTheme>(_onChangeUseSystemTheme);
    on<ThemeEventChangeThemeMode>(_onChangeThemeMode);
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
