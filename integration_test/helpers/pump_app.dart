import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base_template/main.dart';
import 'package:flutter_base_template/app_dependency_injection.dart';
import 'package:flutter_base_template/app_settings.dart' as settings;
import 'package:flutter_base_template/app_dependency_injection.dart'
    as dependency_injection;

/// Bootstraps the real application and pumps [MyApp] for integration tests.
///
/// This mirrors the production bootstrap in `lib/main.dart`:
/// it runs [settings.init] and [dependency_injection.init] before building
/// the widget tree.
///
/// The get_it service locator does not reset itself inside
/// [dependency_injection.init], so calling it twice would throw on
/// re-registration. To keep the helper idempotent across multiple tests,
/// we reset the locator before re-initializing it.
///
/// After pumping, [WidgetTester.pumpAndSettle] is awaited so all startup
/// animations and async frames have completed.
Future<void> pumpApp(WidgetTester tester) async {
  // Ensure a clean service locator so repeated runs do not crash on
  // duplicate registrations.
  await sl.reset();

  // Run the same bootstrap sequence as the production entrypoint.
  await settings.init();
  await dependency_injection.init();

  // Build the real application and let it settle.
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}
