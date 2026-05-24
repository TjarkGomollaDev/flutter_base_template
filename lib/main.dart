import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:flutter_base_template/app_dependency_injection.dart';
import 'package:flutter_base_template/app_router.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'app_settings.dart' as settings;
import 'app_dependency_injection.dart' as dependency_injection;
import 'package:flutter_base_template/app_bloc_provider.dart' as bloc_provider;

Future<void> main() async {
  await settings.init();
  await dependency_injection.init();
  // use the following line to test the onboarding page
  await sl<InterfaceAppSettingsLocalDatasource>().setDeviceOpenFirstTime(value: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: bloc_provider.allBlocProviders,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Mark LXXXV',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.appThemeLight,
            darkTheme: AppTheme.appThemeDark,
            themeMode: state.useSystemTheme ? ThemeMode.system : (state.themeMode ? ThemeMode.light : ThemeMode.dark),
            onGenerateRoute: (settings) => sl<AppRouter>().generateRoute(settings),
            initialRoute: RouteNames.ONBOARDING,
          );
        },
      ),
    );
  }
}
