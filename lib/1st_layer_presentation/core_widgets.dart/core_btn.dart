import 'package:flutter/material.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

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
    final themeData = context.theme;
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: AppConstants.BTN_HEIGHT,
        decoration: BoxDecoration(
          color: color ?? themeData.colorPalette.gray6,
          borderRadius: BorderRadius.circular(AppConstants.RADIUS_XXL),
        ),
        child: Center(
          child: Text(
            name,
            style: themeData.textTheme.labelLarge!.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
