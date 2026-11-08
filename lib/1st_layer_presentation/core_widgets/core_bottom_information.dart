import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$infoText ', style: context.textTheme.bodySmall),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: callback,
          child: Text(
            btnText,
            style: context.textTheme.bodySmall!.copyWith(
              color: context.colorPalette.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
