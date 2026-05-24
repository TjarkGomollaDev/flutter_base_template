import 'package:flutter/material.dart';
import 'package:flutter_base_template/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
      ),
      body: Center(
        child: Text(l10n.placeholderHome),
      ),
    );
  }
}
