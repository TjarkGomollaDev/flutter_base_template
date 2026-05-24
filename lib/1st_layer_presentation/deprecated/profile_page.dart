// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_bottom_information.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/deprecated/widgets/profile_card_container.dart';
import 'package:mark_lxxxv/1st_layer_presentation/deprecated/widgets/settings_data.dart';
import 'package:mark_lxxxv/1st_layer_presentation/deprecated/widgets/settings_group.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/auth_bloc/auth_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_theme.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double overlapAmount = 40;
  final double minHeight = 360;
  double offset = 0;

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    final padding = context.paddingOf;
    double heightCardContainer = max(420 - offset * 0.5, minHeight);
    double settingsContainerPosition = heightCardContainer - overlapAmount;
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            setState(() {
              offset += notification.scrollDelta!;
            });
          }
          return true;
        },
        child: Stack(
          children: [
            // profile card container
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: heightCardContainer,
                child: const ProfileCardContainer(),
              ),
            ),
            // settings container
            Positioned.fill(
              top: settingsContainerPosition,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  //borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.RADIUS_XL)),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    AppConstants.SPACE_VERTICAL_XL.heightSizedBox,
                    // title
                    Text(
                      'Settings',
                      style: themeData.textTheme.titleLarge,
                    ),
                    // AppConstants.SPACE_VERTICAL_XS.heightSizedBox,
                    // const CommonSearchBar(),
                    AppConstants.SPACE_VERTICAL_M.heightSizedBox,
                    // settings
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(AppConstants.RADIUS_L)),
                      child: Column(
                        children: [
                          ...List.generate(
                            settingsData.length,
                            (index) {
                              final groupOfSettings = settingsData[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: SettingsGroup(groupOfSettings: groupOfSettings),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    AppConstants.SPACE_VERTICAL_XXL.heightSizedBox,
                    // Sign Out button
                    CoreBtn(
                      name: 'Sign Out',
                      textColor: AppTheme.redLight,
                      callback: () => context.read<AuthBloc>().add(AuthEventSignOutRequested()),
                    ),
                    AppConstants.SPACE_VERTICAL_M.heightSizedBox,
                    // bottom inforamtion
                    CoreBottomInformation(
                      infoText: 'More information on our website.',
                      btnText: 'Visit here.',
                      callback: () {},
                    ),
                    (padding.bottom + AppConstants.SAFE_AREA_MIN_PADDING_BTM).heightSizedBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
