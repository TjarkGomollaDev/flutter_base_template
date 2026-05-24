// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/application_scaffold/application_scaffold_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/chat/chat_screen/chat_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/error_screen/error_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/landing/landing_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/splash/splash_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/onboarding/onboarding_page.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';

abstract class RouteNames {
  static const SPLASH = '/splash';
  static const ONBOARDING = '/';
  static const SIGN_IN = '/sign_in';
  static const APPLICATION = '/application';
  static const CHAT = '/chat';
  static const ERROR = '/error';

  // profile page settings
  static const SETTINGS_ACCOUNT = '/settings_account';
  static const SETTINGS_CHATS = '/settings_chats';
  static const SETTINGS_GENERAL = '/settings_general';
  static const SETTINGS_NOTIFICATIONS = '/settings_notifications';
  static const SETTINGS_PRIVACY = '/settings_privacy';
  static const SETTINGS_DEVELOPMENT = '/settings_development';
  static const SETTINGS_HELP = '/settings_help';
}

class AppRouter {
  final InterfaceAppSettingsLocalDatasource _appSettingsLocalDatasource;

  AppRouter({required InterfaceAppSettingsLocalDatasource appSettingsLocalDatasource})
      : _appSettingsLocalDatasource = appSettingsLocalDatasource;

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.ONBOARDING:
        if (_appSettingsLocalDatasource.getDeviceOpenFirstTime()) {
          return MaterialPageRoute(
            builder: (context) {
              return const OnboardingPage();
            },
          );
        } else {
          return MaterialPageRoute(
            builder: (context) {
              return const SplashPage();
            },
          );
        }
      case RouteNames.SIGN_IN:
        return MaterialPageRoute(
          builder: (context) {
            return const LandingPage();
          },
        );
      case RouteNames.APPLICATION:
        return MaterialPageRoute(
          builder: (context) {
            return const ApplicationPage();
          },
        );
      case RouteNames.CHAT:
        return MaterialPageRoute(
          builder: (context) => const ChatPage(),
        );
      default:
        // you can also put the sign in page here
        return MaterialPageRoute(
          builder: (context) => const ErrorPage(),
        );
    }
  }
}
