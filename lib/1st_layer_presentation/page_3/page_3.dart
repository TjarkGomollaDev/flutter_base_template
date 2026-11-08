import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('page_3_page'),
      appBar: AppBar(title: Text(context.l10n.page3)),
      body: Center(child: Text(context.l10n.placeholderPage3)),
    );
  }
}
