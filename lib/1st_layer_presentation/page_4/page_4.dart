import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class Page4 extends StatelessWidget {
  const Page4({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      key: const Key('page_4_page'),
      appBar: AppBar(title: Text(l10n.page4)),
      body: Center(child: Text(l10n.placeholderPage4)),
    );
  }
}
