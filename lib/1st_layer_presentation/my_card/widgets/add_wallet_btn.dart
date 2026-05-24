import 'package:flutter/material.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class AddWalletBtn extends StatelessWidget {
  const AddWalletBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: AppConstants.BTN_HEIGHT,
          decoration: BoxDecoration(
            border: Border.all(width: 1.2, color: themeData.colorPalette.onPrimary),
            borderRadius: BorderRadius.circular(AppConstants.RADIUS_XXL),
          ),
          child: Row(
            children: [
              AppConstants.SPACE_HORIZONTAL_M.widthSizedBox,
              Icon(
                Icons.wallet,
                size: 30,
              ),
              AppConstants.SPACE_HORIZONTAL_S.widthSizedBox,
              Text(
                'Add to Apple Wallet',
                style: themeData.textTheme.bodyMedium,
              ),
              Spacer(),
              Icon(
                Icons.add,
                size: 30,
              ),
              AppConstants.SPACE_HORIZONTAL_M.widthSizedBox,
            ],
          ),
        ),
      ),
    );
  }
}
