import 'package:flutter/widgets.dart';
import 'package:flutter_base_template/app_dependency_injection.dart'
    as dependency_injection;
import 'package:flutter_base_template/app_settings.dart' as settings;
import 'package:flutter_base_template/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

extension PumpAppTester on WidgetTester {
  Future<void> pumpApp() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await pumpWidget(const SizedBox.shrink());
    await dependency_injection.sl.reset();
    settings.init();
    await dependency_injection.init();
    await pumpWidget(const MyApp());
    await pumpAndSettle();
  }
}

Future<void> pumpApp(WidgetTester tester) => tester.pumpApp();
