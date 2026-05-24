import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';

class ReferFriend extends StatelessWidget {
  const ReferFriend({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.RADIUS_L),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/refer_friend.jpg'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.SPACE_HORIZONTAL_XL,
              vertical: AppConstants.SPACE_VERTICAL_L),
          color: AppTheme.black.withAlpha(102),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Refer and earn 10 €',
                      style: themeData.textTheme.titleSmall!.copyWith(color: AppTheme.white),
                    ),
                    AppConstants.SPACE_VERTICAL_XS.heightSizedBox,
                    Text(
                      'Invite your friends to join our App and earn each 10 € in cash',
                      style: themeData.textTheme.bodyMedium!.copyWith(color: AppTheme.grayLight3),
                    ),
                  ],
                ),
              ),
              AppConstants.SPACE_HORIZONTAL_XL.widthSizedBox,
              CoreLabelBtn(
                name: 'Get',
                color: AppTheme.white.withAlpha(50),
                textColor: AppTheme.white,
                callback: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
