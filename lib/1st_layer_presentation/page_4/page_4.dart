import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class Page4 extends StatelessWidget {
  const Page4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('page_4_page'),
      appBar: AppBar(title: Text(context.l10n.page4)),
      body: Center(child: Text(context.l10n.placeholderPage4)),
    );
  }
}
