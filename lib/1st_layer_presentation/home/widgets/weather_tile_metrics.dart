import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class WeatherTileMetrics extends StatelessWidget {
  final String name;
  final String value;
  const WeatherTileMetrics({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: themeData.textTheme.bodySmall,
        ),
        AppConstants.SPACE_VERTICAL_XXS.heightSizedBox,
        Text(
          value,
          style: themeData.textTheme.bodySmall!.copyWith(color: themeData.colorPalette.gray1),
        ),
      ],
    );
  }
}
