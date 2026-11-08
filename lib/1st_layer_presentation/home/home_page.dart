import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('home_page'),
      appBar: AppBar(title: Text(context.l10n.home)),
      body: Center(child: Text(context.l10n.placeholderHome)),
    );
  }
}
