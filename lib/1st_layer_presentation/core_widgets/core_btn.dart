import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class CoreBtn extends StatelessWidget {
  final String name;
  final Color? color;
  final Color? textColor;
  final VoidCallback callback;

  const CoreBtn({
    super.key,
    required this.name,
    this.color,
    this.textColor,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: callback,
      child: Container(
        height: AppConstants.BTN_HEIGHT,
        decoration: BoxDecoration(
          color: color ?? context.colorPalette.gray6,
          borderRadius: BorderRadius.circular(AppConstants.RADIUS_XXL),
        ),
        child: Center(
          child: Text(
            name,
            style: context.textTheme.labelLarge!.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
