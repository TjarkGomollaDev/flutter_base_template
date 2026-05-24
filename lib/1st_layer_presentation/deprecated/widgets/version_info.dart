import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VersionInfo extends StatelessWidget {
  const VersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final tapGestureRecognizer = TapGestureRecognizer()..onTap = () {};
    final themeData = context.theme;
    return Container(
      height: AppConstants.BTN_HEIGHT,
      decoration: BoxDecoration(
        color: themeData.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppConstants.RADIUS_L),
      ),
      child: Center(
        child: ListTile(
          dense: true,
          horizontalTitleGap: AppConstants.SPACE_HORIZONTAL_L,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppConstants.SPACE_HORIZONTAL_L),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppTheme.grayLight1,
              borderRadius: BorderRadius.circular(AppConstants.RADIUS_S),
            ),
            child: Icon(
              MdiIcons.heartOutline,
              size: 30,
              color: themeData.colorPalette.primary,
            ),
          ),
          title: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Made with Love in Münster. ',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: themeData.colorScheme.onSecondaryContainer,
                  ),
                ),
                TextSpan(
                  text: 'Contact Us.\n',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: themeData.colorScheme.surfaceTint,
                  ),
                  recognizer: tapGestureRecognizer,
                ),
                TextSpan(
                  text: 'Stable Version 1.2.6',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: themeData.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
