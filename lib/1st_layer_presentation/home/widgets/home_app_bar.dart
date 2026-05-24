import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mark_lxxxv/1st_layer_presentation/my_card/card_bottom_sheet.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/home/widgets/hello_user.dart';
import 'package:mark_lxxxv/1st_layer_presentation/profile/profile_bottom_sheet.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    final avatarHeight = 40;
    final gap = 20;
    return SliverAppBar(
      floating: false,
      expandedHeight: 120 + gap.toDouble(),
      pinned: true,
      surfaceTintColor: themeData.colorPalette.gray1,
      backgroundColor: themeData.colorPalette.primary,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            double top = constraints.biggest.height;
            return FlexibleSpaceBar(
              expandedTitleScale: 1,
              title: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      if (top > 120 + avatarHeight + gap) ...[
                        AnimatedOpacity(
                          duration: Duration.zero,
                          opacity: ((top - 180) / (185 - 180)).clamp(0.0, 1.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ProfileBottomSheet.showProfileBottomSheet(context: context);
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage('assets/backgrounds/Maurice.jpeg'),
                                  ),
                                ),
                                CoreLabelBtn(
                                  name: 'Card',
                                  callback: () {
                                    FocusScope.of(context).unfocus();
                                    CardBottomSheet.showCardBottomSheet(context: context);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        gap.heightSizedBox,
                      ],
                      HelloUser(),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
