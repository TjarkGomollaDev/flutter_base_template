import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/application_scaffold/application_scaffold.dart';
import 'package:flutter_base_template/1st_layer_presentation/error_screen/error_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/home_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/page_2/page_2.dart';
import 'package:flutter_base_template/1st_layer_presentation/page_3/page_3.dart';
import 'package:flutter_base_template/1st_layer_presentation/page_4/page_4.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _sectionANavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sectionANav');
  final GlobalKey<NavigatorState> _sectionBNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sectionBNav');
  final GlobalKey<NavigatorState> _sectionCNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sectionCNav');
  final GlobalKey<NavigatorState> _sectionDNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sectionDNav');

  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      errorBuilder: (context, state) => const ErrorPage(),
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ApplicationPage(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              navigatorKey: _sectionANavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _sectionBNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: '/page_2',
                  builder: (context, state) => const Page2(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _sectionCNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: '/page_3',
                  builder: (context, state) => const Page3(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _sectionDNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: '/page_4',
                  builder: (context, state) => const Page4(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
