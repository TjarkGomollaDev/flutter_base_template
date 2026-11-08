import 'package:flutter/material.dart';
import 'package:flutter_base_template/2nd_layer_application/application/locale_bloc/locale_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/app_bloc_observer.dart';
import 'package:flutter_base_template/app_bloc_provider.dart' as bloc_provider;
import 'package:flutter_base_template/app_dependency_injection.dart'
    as dependency_injection;
import 'package:flutter_base_template/app_router.dart';
import 'package:flutter_base_template/app_settings.dart' as settings;
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final sl = dependency_injection.sl;

Future<void> main() async {
  settings.init();
  await dependency_injection.init();
  Bloc.observer = AppBlocObserver(logger: sl());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: bloc_provider.allBlocProviders,
      child: Builder(
        builder: (context) {
          final themeState = context.watch<ThemeBloc>().state;
          final localeState = context.watch<LocaleBloc>().state;

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.appThemeLight,
            darkTheme: AppTheme.appThemeDark,
            themeMode: themeState.useSystemTheme
                ? ThemeMode.system
                : (themeState.themeMode ? ThemeMode.light : ThemeMode.dark),
            locale: localeState.locale,
            routerConfig: sl<AppRouter>().router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
