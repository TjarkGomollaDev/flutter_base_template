import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/pump_app.dart';

void main() {
  testWidgets('renders home page on launch', (tester) async {
    await tester.pumpApp();
    expect(find.byKey(const Key('home_page')), findsOneWidget);
  });

  testWidgets('navigates between tabs via bottom navigation bar', (
    tester,
  ) async {
    await tester.pumpApp();

    await tester.tap(find.byKey(const Key('nav_tab_page_2')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page_2_page')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav_tab_page_3')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page_3_page')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav_tab_page_4')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page_4_page')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav_tab_home')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home_page')), findsOneWidget);
  });
}
