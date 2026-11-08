import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAppSettingsLocalDatasource
    implements InterfaceAppSettingsLocalDatasource {
  bool useSystemTheme;
  bool themeMode;
  String? languageCode;

  FakeAppSettingsLocalDatasource({
    this.useSystemTheme = true,
    this.themeMode = true,
    this.languageCode,
  });

  @override
  Future<void> setUseSystemTheme({required bool value}) async {
    useSystemTheme = value;
  }

  @override
  Future<bool> getUseSystemTheme() async => useSystemTheme;

  @override
  Future<void> setThemeMode({required bool value}) async {
    themeMode = value;
  }

  @override
  Future<bool> getThemeMode() async => themeMode;

  @override
  Future<void> setLanguageCode({required String? code}) async {
    languageCode = code;
  }

  @override
  Future<String?> getLanguageCode() async => languageCode;
}

void main() {
  test('loads persisted settings on startup', () async {
    final datasource = FakeAppSettingsLocalDatasource(
      useSystemTheme: false,
      themeMode: false,
    );
    final bloc = ThemeBloc(appSettingsLocalDatasource: datasource);
    addTearDown(bloc.close);

    await expectLater(
      bloc.stream,
      emits(const ThemeState(useSystemTheme: false, themeMode: false)),
    );
  });

  test(
    'processes toggle events sequentially without race conditions',
    () async {
      final datasource = FakeAppSettingsLocalDatasource(
        useSystemTheme: false,
        themeMode: true,
      );
      final bloc = ThemeBloc(appSettingsLocalDatasource: datasource);
      addTearDown(bloc.close);

      bloc.add(const ThemeEventChangeUseSystemTheme());
      bloc.add(const ThemeEventChangeThemeMode());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const ThemeState(useSystemTheme: false, themeMode: true),
          const ThemeState(useSystemTheme: true, themeMode: true),
          const ThemeState(useSystemTheme: true, themeMode: false),
        ]),
      );

      expect(datasource.useSystemTheme, isTrue);
      expect(datasource.themeMode, isFalse);
    },
  );
}
