import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class CoreLabelBtn extends StatelessWidget {
  final String name;
  final Color? color;
  final Color? textColor;
  final VoidCallback callback;

  const CoreLabelBtn({
    super.key,
    required this.name,
    this.color,
    this.textColor,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: name,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: callback,
        child: UnconstrainedBox(
          child: Container(
            height: AppConstants.LABEL_BTN_HEIGHT,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.SPACE_HORIZONTAL_M,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.RADIUS_XL),
              color: color ?? context.colorPalette.gray6,
            ),
            child: Center(
              child: Text(
                name,
                style: context.textTheme.labelMedium!.copyWith(
                  color: textColor ?? context.colorPalette.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
