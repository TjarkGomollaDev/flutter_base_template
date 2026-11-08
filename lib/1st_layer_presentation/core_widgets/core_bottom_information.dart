import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class CoreBottomInformation extends StatelessWidget {
  final String infoText;
  final String btnText;
  final VoidCallback callback;

  const CoreBottomInformation({
    super.key,
    required this.infoText,
    required this.btnText,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$infoText ', style: themeData.textTheme.bodySmall),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: callback,
          child: Text(
            btnText,
            style: themeData.textTheme.bodySmall!.copyWith(
              color: themeData.colorPalette.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
