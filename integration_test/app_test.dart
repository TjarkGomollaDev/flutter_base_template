import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/pump_app.dart';

void main() {
  // Capture the integration test binding so we can drive screenshots.
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Prefix screenshots with the platform name so an iOS and an Android run do
  // not overwrite each other's files (relevant when testing both platforms).
  String shot(String name) => '${Platform.operatingSystem}_$name';

  testWidgets('navigates all four tabs and captures screenshots',
      (WidgetTester tester) async {
    // Bootstrap and pump the real app.
    await pumpApp(tester);

    // Both iOS and Android require converting the Flutter surface to an image
    // before any screenshot can be taken.
    if (Platform.isIOS || Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
    }

    // Tab 1: Home.
    expect(find.byKey(const Key('home_page')), findsOneWidget);
    await binding.takeScreenshot(shot('01_home'));

    // Tab 2: Search page.
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page_2_page')), findsOneWidget);
    await binding.takeScreenshot(shot('02_page_2'));

    // Tab 3: Favorite page.
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page_3_page')), findsOneWidget);
    await binding.takeScreenshot(shot('03_page_3'));

    // Tab 4: Person page.
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page_4_page')), findsOneWidget);
    await binding.takeScreenshot(shot('04_page_4'));
  });
}
