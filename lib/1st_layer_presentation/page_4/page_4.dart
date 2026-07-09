import 'package:flutter/material.dart';
import 'package:flutter_base_template/l10n/app_localizations.dart';

class Page4 extends StatelessWidget {
  const Page4({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // Test anchor: uniquely identifies page 4 in UI tests.
      key: const Key('page_4_page'),
      appBar: AppBar(title: Text(l10n.page4)),
      body: Center(
        child: Text(l10n.placeholderPage4),
      ),
    );
  }
}
