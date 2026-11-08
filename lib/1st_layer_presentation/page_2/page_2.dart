import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('page_2_page'),
      appBar: AppBar(title: Text(context.l10n.page2)),
      body: Center(child: Text(context.l10n.placeholderPage2)),
    );
  }
}
