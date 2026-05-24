import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_label_icon_btn.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ContentFront extends StatelessWidget {
  const ContentFront({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.PAGE_PADDING_HORIZONTAL,
        vertical: AppConstants.SPACE_VERTICAL_S,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/backgrounds/Maurice.jpeg'),
                radius: 50,
              ),
              const Spacer(),
              CoreLabelIconBtn(
                icon: MdiIcons.qrcode,
                color: Colors.white,
                callback: () {},
              ),
              AppConstants.SPACE_HORIZONTAL_XS.widthSizedBox,
              CoreLabelIconBtn(
                icon: Boxicons.bx_scan,
                color: AppTheme.white,
                callback: () {},
              ),
              AppConstants.SPACE_HORIZONTAL_XS.widthSizedBox,
              CoreLabelIconBtn(
                icon: Icons.add,
                color: AppTheme.white,
                callback: () {},
              ),
            ],
          ),
          const Spacer(),
          Text(
            'maurice.bonnes@live.de',
            style: themeData.textTheme.bodyLarge!.copyWith(color: AppTheme.grayLight3),
          ),
          Text(
            'Maurice',
            style: themeData.textTheme.titleMedium!.copyWith(color: Colors.white),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
