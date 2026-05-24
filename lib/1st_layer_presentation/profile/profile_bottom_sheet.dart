import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_bottom_information.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_bottom_sheet.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_label_icon_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/profile/widgets/profile_settings.dart';
import 'package:mark_lxxxv/1st_layer_presentation/profile/widgets/refer_friend.dart';
import 'package:mark_lxxxv/2nd_layer_application/application/home_bloc/home_bloc.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/auth_bloc/auth_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class ProfileBottomSheet {
  static void showProfileBottomSheet({required BuildContext context}) {
    CoreBottomSheet.showCommonBottomSheet(
      context: context,
      builder: (context) {
        final themeData = context.theme;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // profile picture
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/backgrounds/Maurice.jpeg'),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CoreLabelIconBtn(
                        icon: Icons.add,
                        callback: () {},
                      ),
                    )
                  ],
                ),
                AppConstants.SPACE_VERTICAL_L.heightSizedBox,
                // username
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current) => previous.username != current.username,
                      builder: (context, state) {
                        return Text(
                          state.username,
                          style: themeData.textTheme.titleLarge,
                        );
                      },
                    ),
                    CoreLabelBtn(
                      name: 'Edit',
                      callback: () {},
                    )
                  ],
                ),
                AppConstants.SPACE_VERTICAL_XXL.heightSizedBox,
                // refer a friend
                ReferFriend(),
                AppConstants.SPACE_VERTICAL_XL.heightSizedBox,

                // profile settings
                ProfileSettings(),
                AppConstants.SPACE_VERTICAL_XL.heightSizedBox,
                // sign out button
                CoreBtn(
                  name: 'Sign Out',
                  textColor: themeData.colorPalette.error,
                  callback: () => context.read<AuthBloc>().add(AuthEventSignOutRequested()),
                ),
                AppConstants.SPACE_VERTICAL_XL.heightSizedBox,
                // bottom inforamtion
                CoreBottomInformation(
                  infoText: 'More information and help on our website.',
                  btnText: 'Visit here.',
                  callback: () {},
                ),
                // to equalize bottom safe area
                MediaQuery.paddingOf(context).bottom.heightSizedBox,
              ],
            ),
          ),
        );
      },
    );
  }
}
