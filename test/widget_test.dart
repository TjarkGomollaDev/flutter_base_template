// Basic launch smoke test for the application.
//
// It runs the same bootstrap sequence as the production entrypoint
// (`lib/main.dart`) and verifies that the app launches and renders the
// home page.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:flutter_base_template/main.dart';
import 'package:flutter_base_template/app_dependency_injection.dart';
import 'package:flutter_base_template/app_settings.dart' as settings;
import 'package:flutter_base_template/app_dependency_injection.dart'
    as dependency_injection;

void main() {
  testWidgets('app launches and shows the home page',
      (WidgetTester tester) async {
    // Host-VM widget tests have no real platform, so back SharedPreferencesAsync
    // with an in-memory implementation before the DI bootstrap uses it.
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();

    // Reset the service locator so the test is idempotent across runs,
    // since dependency_injection.init() does not reset it itself.
    await sl.reset();

    // Run the real bootstrap sequence.
    await settings.init();
    await dependency_injection.init();

    // Build the app and let startup animations settle.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // The home page should be visible on launch.
    expect(find.byKey(const Key('home_page')), findsOneWidget);
  });
}
