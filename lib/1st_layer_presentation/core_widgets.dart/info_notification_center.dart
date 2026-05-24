import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum InfoNotificationType { error, succes }

class InfoNotificationCenter {
  static Flushbar? _currentFlushbar;

  static Future<void> showInfoNotification({
    required BuildContext context,
    required String message,
    required InfoNotificationType type,
  }) async {
    if (_currentFlushbar != null) {
      _currentFlushbar!.dismiss();
    }
    final themeData = context.theme;
    _currentFlushbar = Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.PAGE_PADDING_HORIZONTAL,
        vertical: AppConstants.SPACE_VERTICAL_M,
      ),
      backgroundColor: switch (type) {
        InfoNotificationType.error => themeData.colorPalette.error,
        InfoNotificationType.succes => themeData.colorPalette.success,
      },
      messageText: Row(
        children: [
          Center(
            child: Icon(
              switch (type) {
                InfoNotificationType.error => MdiIcons.alertCircleOutline,
                InfoNotificationType.succes => MdiIcons.checkCircleOutline,
              },
              size: AppConstants.TILE_ICON_SIZE,
              color: AppTheme.white,
            ),
          ),
          AppConstants.SPACE_HORIZONTAL_L.widthSizedBox,
          Flexible(
            child: Text(
              message,
              style: themeData.textTheme.bodyMedium!.copyWith(color: AppTheme.white),
            ),
          ),
        ],
      ),
      //borderRadius: BorderRadius.circular(AppConstants.RADIUS_L),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 5),
      animationDuration: const Duration(seconds: 1),
      // reverseDuration: const Duration(milliseconds: 1),
      shouldIconPulse: false,
      isDismissible: true,
      reverseAnimationCurve: Curves.linear,
    )..show(context);
  }
}
