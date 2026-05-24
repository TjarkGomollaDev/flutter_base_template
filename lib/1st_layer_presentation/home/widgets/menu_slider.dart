import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class MenuSlider extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final String imagePath;
  final IconData icon;

  const MenuSlider({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Container(
      width: 180,
      height: 250,
      margin: EdgeInsets.only(
        left: index == 0 ? AppConstants.PAGE_PADDING_HORIZONTAL : 0,
        right: AppConstants.SPACE_HORIZONTAL_S,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.RADIUS_L),
        color: themeData.colorPalette.gray6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
            height: 180,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.RADIUS_M),
                image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.SPACE_HORIZONTAL_M),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: themeData.textTheme.titleSmall,
                ),
                Text(
                  subtitle,
                  style:
                      themeData.textTheme.bodyMedium!.copyWith(color: themeData.colorPalette.gray1),
                ),
                AppConstants.SPACE_VERTICAL_XS.heightSizedBox,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
