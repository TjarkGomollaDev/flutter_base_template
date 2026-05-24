import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_base_template/2nd_layer_application/application/ai_chat/ai_chat_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/application_bloc/application_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/chat_bloc/chat_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/chat_list_bloc/chat_list_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/home_bloc/home_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/search_bloc/search_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/auth_bloc/auth_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/reset_password_bloc/reset_password_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/onboarding/onboarding_bloc/onboarding_bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_ai_chat_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_chat_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_chatbot_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_storage_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_user_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/local_datasources/app_settings_local_datasource.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/repositories/ai_chat_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/repositories/auth_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/repositories/chat_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/repositories/chatbot_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/repositories/storage_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/repositories/user_repository.dart';
import 'package:flutter_base_template/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// create service locator
final GetIt sl = GetIt.I;

Future<void> init() async {
  // #### STATE MANAGEMANT #####################################
  // onboarding
  sl.registerFactory(() => OnboardingBloc(appSettingsLocalDatasource: sl()));
  // auth
  sl.registerFactory(() => SignInBloc(authRepository: sl(), userRepository: sl()));
  sl.registerFactory(() => SignUpBloc(authRepository: sl(), userRepository: sl()));
  sl.registerFactory(() => ResetPasswordBloc(authRepository: sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  // theme
  sl.registerFactory(() => ThemeBloc(appSettingsLocalDatasource: sl()));
  // application
  sl.registerFactory(() => ApplicationBloc(appSettingsLocalDatasource: sl()));
  sl.registerFactory(() => HomeBloc(userRepository: sl()));
  sl.registerFactory(() => SearchBloc(appSettingsLocalDatasource: sl()));
  // ai chat feature
  sl.registerFactory(() => AiChatBloc(
        aiChatRepository: sl(),
        userRepository: sl(),
        chatbotRepository: sl(),
      ));
  // chat feature
  sl.registerFactory(() => ChatBloc(chatRepository: sl()));
  sl.registerFactory(
      () => ChatListBloc(authRepository: sl(), userRepository: sl(), chatRepository: sl()));

  // #### ROUTER ###############################################
  sl.registerLazySingleton(() => AppRouter(appSettingsLocalDatasource: sl()));

  // #### LOCAL DATASOURCES ####################################
  sl.registerLazySingleton<InterfaceAppSettingsLocalDatasource>(
      () => AppSettingsLocalDatasource(sharedPreferences: sl()));

  // #### EXTERN ###############################################
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // #### REPOSITORIES #########################################
  sl.registerLazySingleton<InterfaceAuthRepository>(() => AuthRepository(firebaseAuth: sl()));
  sl.registerLazySingleton<InterfaceUserRepository>(() => UserRepository(firestore: sl()));
  sl.registerLazySingleton<InterfaceChatRepository>(() => ChatRepository(firestore: sl()));
  sl.registerLazySingleton<InterfaceStorageRepository>(() => StorageRepository(storage: sl()));
  sl.registerLazySingleton<InterfaceAiChatRepository>(() => AiChatRepository(firestore: sl()));
  sl.registerLazySingleton<InterfaceChatbotRepository>(() => ChatbotRepository());
}
