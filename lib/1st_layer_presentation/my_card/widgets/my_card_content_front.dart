import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';

class MyCardContentFront extends StatelessWidget {
  const MyCardContentFront({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.SPACE_HORIZONTAL_L,
        vertical: AppConstants.SPACE_VERTICAL_S,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // profile picture
              const CircleAvatar(
                backgroundImage: AssetImage('assets/backgrounds/Maurice.jpeg'),
                radius: 50,
              ),
              const Spacer(),
              // buttons
              CoreLabelBtn(
                name: 'Share',
                color: AppTheme.white.withAlpha(38),
                textColor: AppTheme.white,
                callback: () {},
              ),
              AppConstants.SPACE_HORIZONTAL_XS.widthSizedBox,
              CoreLabelBtn(
                name: 'Scan',
                color: AppTheme.white.withAlpha(38),
                textColor: AppTheme.white,
                callback: () {},
              ),
            ],
          ),
          const Spacer(),
          // email
          Text(
            'test.user@test.de',
            style: themeData.textTheme.bodyLarge!.copyWith(color: AppTheme.white),
          ),
          // username
          Text(
            'Maurice',
            style: themeData.textTheme.titleMedium!.copyWith(color: AppTheme.white),
          ),
        ],
      ),
    );
  }
}
