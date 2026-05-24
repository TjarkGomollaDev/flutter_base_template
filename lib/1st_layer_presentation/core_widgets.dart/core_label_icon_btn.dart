import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class CoreLabelIconBtn extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Color? iconColor;
  final BoxShadow? boxShadow;
  final VoidCallback callback;

  const CoreLabelIconBtn({
    super.key,
    required this.icon,
    this.color,
    this.iconColor,
    this.boxShadow,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final colorPalette = context.colorPalette;
    return GestureDetector(
      onTap: callback,
      child: UnconstrainedBox(
        child: Container(
          height: AppConstants.LABEL_BTN_HEIGHT,
          width: AppConstants.LABEL_BTN_HEIGHT,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.RADIUS_XL),
              color: color ?? colorPalette.gray5,
              boxShadow: boxShadow == null ? null : [boxShadow!]),
          child: Icon(
            icon,
            size: 20,
            color: iconColor ?? colorPalette.onPrimary,
          ),
        ),
      ),
    );
  }
}
