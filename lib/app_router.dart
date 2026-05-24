// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/application_scaffold/application_scaffold_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/error_screen/error_page.dart';

abstract class RouteNames {
  static const APPLICATION = '/';
  static const ERROR = '/error';
}

class AppRouter {
  AppRouter();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.APPLICATION:
        return MaterialPageRoute(
          builder: (context) {
            return const ApplicationPage();
          },
        );
      case RouteNames.ERROR:
        return MaterialPageRoute(
          builder: (context) => const ErrorPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const ErrorPage(),
        );
    }
  }
}
