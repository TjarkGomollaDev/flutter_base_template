import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_base_template/2nd_layer_application/application/application_bloc/application_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/home_bloc/home_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_example_item_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/local_datasources/app_settings_local_datasource.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/repositories/example_item_repository.dart';
import 'package:flutter_base_template/app_router.dart';

// create service locator
final GetIt sl = GetIt.I;

Future<void> init() async {
  // #### STATE MANAGEMANT #####################################
  // theme
  sl.registerFactory(() => ThemeBloc(appSettingsLocalDatasource: sl()));
  // application
  sl.registerFactory(() => ApplicationBloc(appSettingsLocalDatasource: sl()));
  sl.registerFactory(() => HomeBloc());

  // #### ROUTER ###############################################
  sl.registerLazySingleton(() => AppRouter());

  // #### LOCAL DATASOURCES ####################################
  sl.registerLazySingleton<InterfaceAppSettingsLocalDatasource>(
      () => AppSettingsLocalDatasource(sharedPreferences: sl()));

  // #### EXTERN ###############################################
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // #### REPOSITORIES #########################################
  sl.registerLazySingleton<InterfaceExampleItemRepository>(() => ExampleItemRepository());
}
