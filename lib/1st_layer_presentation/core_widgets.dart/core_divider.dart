import 'package:flutter/material.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class CoreDivider extends StatelessWidget {
  const CoreDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: context.theme.colorPalette.gray5);
  }
}
