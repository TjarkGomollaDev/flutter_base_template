import 'package:flutter/material.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class HomeNavBarItem extends StatelessWidget {
  final String name;
  final String iconAsset;
  final VoidCallback callback;

  const HomeNavBarItem({
    super.key,
    required this.name,
    required this.iconAsset,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Expanded(
      child: GestureDetector(
        onTap: callback,
        child: Container(
          height: AppConstants.NAV_BAR_BTN_HEIGT,
          decoration: BoxDecoration(
            color: themeData.colorPalette.onPrimary,
            borderRadius: BorderRadius.circular(AppConstants.RADIUS_M),
            boxShadow: [themeData.shadowPalette.onPrimaryBtnShadow],
          ),
          child: Center(
            child: Row(
              children: [
                AppConstants.SPACE_HORIZONTAL_M.widthSizedBox,
                Image.asset(
                  iconAsset,
                  height: AppConstants.NAV_BAR_ICON_SIZE,
                  color: themeData.colorPalette.primary,
                ),
                AppConstants.SPACE_HORIZONTAL_S.widthSizedBox,
                Text(
                  name,
                  style: themeData.textTheme.labelLarge!.copyWith(
                    color: themeData.colorPalette.primary,
                    fontSize: 17,
                  ),
                ),
                Spacer(),
                AppConstants.SPACE_HORIZONTAL_S.widthSizedBox,
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: themeData.colorPalette.primary,
                  size: AppConstants.TILE_ICON_ARROW_SIZE,
                ),
                AppConstants.SPACE_HORIZONTAL_M.widthSizedBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
