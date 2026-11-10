import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_app_settings_local_datasource.dart';

void main() {
  test('loads persisted settings on startup', () async {
    final datasource = FakeAppSettingsLocalDatasource(
      useSystemTheme: false,
      isLightMode: false,
    );
    final bloc = ThemeBloc(appSettingsLocalDatasource: datasource);
    addTearDown(bloc.close);

    await expectLater(
      bloc.stream,
      emits(const ThemeState(useSystemTheme: false, isLightMode: false)),
    );
  });

  test(
    'processes toggle events sequentially without race conditions',
    () async {
      final datasource = FakeAppSettingsLocalDatasource(
        useSystemTheme: false,
        isLightMode: true,
      );
      final bloc = ThemeBloc(appSettingsLocalDatasource: datasource);
      addTearDown(bloc.close);

      bloc.add(const ThemeEventChangeUseSystemTheme());
      bloc.add(const ThemeEventChangeThemeMode());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const ThemeState(useSystemTheme: false, isLightMode: true),
          const ThemeState(useSystemTheme: true, isLightMode: true),
          const ThemeState(useSystemTheme: true, isLightMode: false),
        ]),
      );

      expect(datasource.useSystemTheme, isTrue);
      expect(datasource.isLightMode, isFalse);
    },
  );
}
