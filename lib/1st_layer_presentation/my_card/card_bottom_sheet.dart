import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/my_card/widgets/add_wallet_btn.dart';
import 'package:flutter_base_template/1st_layer_presentation/my_card/widgets/card_container.dart';
import 'package:flutter_base_template/1st_layer_presentation/my_card/widgets/card_settings.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_bottom_information.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_bottom_sheet.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';

class CardBottomSheet {
  static void showCardBottomSheet({required BuildContext context}) {
    CoreBottomSheet.showCommonBottomSheet(
      context: context,
      builder: (context) {
        final themeData = context.theme;
        return SafeArea(
          minimum: const EdgeInsets.only(
            bottom: AppConstants.SAFE_AREA_MIN_PADDING_BTM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // title
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
                child: Text(
                  'My Card',
                  style: themeData.textTheme.titleLarge,
                ),
              ),
              CardContainer(),

              AddWalletBtn(),
              AppConstants.SPACE_VERTICAL_XL.heightSizedBox,
              CardSettings(),
              AppConstants.SPACE_VERTICAL_XL.heightSizedBox,
              // bottom inforamtion
              CoreBottomInformation(
                infoText: 'More information and help on our website.',
                btnText: 'Visit here.',
                callback: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
