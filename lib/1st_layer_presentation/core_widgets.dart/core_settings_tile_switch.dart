import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class CoreSettingsTileSwitch extends StatelessWidget {
  final String name;
  final String text;
  final IconData icon;
  final BlocBuilder blocBuilder;

  const CoreSettingsTileSwitch({
    super.key,
    required this.name,
    required this.text,
    required this.icon,
    required this.blocBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.SPACE_VERTICAL_XS),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppConstants.TILE_ICON_SIZE,
          ),
          AppConstants.SPACE_HORIZONTAL_L.widthSizedBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: themeData.textTheme.titleSmall,
              ),
              AppConstants.SPACE_VERTICAL_XXS.heightSizedBox,
              Text(
                text,
                style:
                    themeData.textTheme.bodyMedium!.copyWith(color: themeData.colorPalette.gray1),
              ),
            ],
          ),
          AppConstants.SPACE_HORIZONTAL_L.widthSizedBox,
          Spacer(),
          blocBuilder,
        ],
      ),
    );
  }
}
