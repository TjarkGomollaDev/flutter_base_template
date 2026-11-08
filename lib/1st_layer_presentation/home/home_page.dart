import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      key: const Key('home_page'),
      appBar: AppBar(title: Text(l10n.home)),
      body: Center(child: Text(l10n.placeholderHome)),
    );
  }
}
