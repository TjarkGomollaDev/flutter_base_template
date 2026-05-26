import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_base_template/1st_layer_presentation/application_scaffold/application_scaffold.dart';
import 'package:flutter_base_template/1st_layer_presentation/error_screen/error_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/home_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/page_2/page_2.dart';
import 'package:flutter_base_template/1st_layer_presentation/page_3/page_3.dart';
import 'package:flutter_base_template/1st_layer_presentation/page_4/page_4.dart';

// Global keys for navigation state
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');
final _sectionBNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionBNav');
final _sectionCNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionCNav');
final _sectionDNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionDNav');

class AppRouter {
  final GoRouter router;

  AppRouter() : router = _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    errorBuilder: (context, state) => const ErrorPage(),
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return ApplicationPage(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          // Branch Home
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/',
                builder: (BuildContext context, GoRouterState state) =>
                    const HomePage(),
              ),
            ],
          ),
          // Branch Page 2
          StatefulShellBranch(
            navigatorKey: _sectionBNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/page_2',
                builder: (BuildContext context, GoRouterState state) =>
                    const Page2(),
              ),
            ],
          ),
          // Branch Page 3
          StatefulShellBranch(
            navigatorKey: _sectionCNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/page_3',
                builder: (BuildContext context, GoRouterState state) =>
                    const Page3(),
              ),
            ],
          ),
          // Branch Page 4
          StatefulShellBranch(
            navigatorKey: _sectionDNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/page_4',
                builder: (BuildContext context, GoRouterState state) =>
                    const Page4(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
