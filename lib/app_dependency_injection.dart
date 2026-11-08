import 'package:flutter_base_template/2nd_layer_application/application/locale_bloc/locale_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_example_item_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/local_datasources/app_settings_local_datasource.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/repositories/example_item_repository.dart';
import 'package:flutter_base_template/app_router.dart';
import 'package:flutter_base_template/core/network/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.I;

Future<void> init() async {
  final sharedPreferencesAsync = SharedPreferencesAsync();
  sl.registerLazySingleton(() => sharedPreferencesAsync);

  sl.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.none,
      ),
    ),
  );

  sl.registerLazySingleton<ApiClient>(() => ApiClient(logger: sl()));

  sl.registerFactory(() => ThemeBloc(appSettingsLocalDatasource: sl()));
  sl.registerFactory(() => LocaleBloc(appSettingsLocalDatasource: sl()));

  sl.registerLazySingleton<AppRouter>(
    AppRouter.new,
    dispose: (appRouter) => appRouter.router.dispose(),
  );

  sl.registerLazySingleton<InterfaceAppSettingsLocalDatasource>(
    () => AppSettingsLocalDatasource(sharedPreferencesAsync: sl()),
  );

  sl.registerLazySingleton<InterfaceExampleItemRepository>(
    () => ExampleItemRepository(apiClient: sl(), logger: sl()),
  );
}
