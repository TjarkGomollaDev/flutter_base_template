import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class CoreBottomSheet {
  static void showCommonBottomSheet({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      barrierColor: context.theme.colorPalette.gray1.withAlpha(76),
      isScrollControlled: true,
      builder: builder,
    );
  }
}
