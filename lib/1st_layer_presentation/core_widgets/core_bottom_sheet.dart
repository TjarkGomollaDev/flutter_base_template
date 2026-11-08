import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class CoreBottomSheet {
  static Future<T?> showCommonBottomSheet<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) => showModalBottomSheet<T>(
    useSafeArea: true,
    context: context,
    barrierColor: context.colorPalette.gray1.withAlpha(76),
    isScrollControlled: true,
    builder: builder,
  );
}
