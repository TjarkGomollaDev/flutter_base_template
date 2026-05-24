import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_label_icon_btn.dart';
import 'package:flutter_base_template/2nd_layer_application/application/application_bloc/application_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class AiChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AiChatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.AI_CHAT_APP_BAR_HEIGHT);

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return ClipRRect(
      child: BackdropFilter(
        filter: AppConstants.BLUR_FILTER,
        child: Container(
          color: themeData.colorPalette.gray6.withAlpha(230),
          child: SafeArea(
            child: Stack(
              children: [
                // buttons
                Positioned(
                  bottom: AppConstants.SPACE_VERTICAL_S - 4,
                  left: AppConstants.PAGE_PADDING_HORIZONTAL,
                  right: AppConstants.PAGE_PADDING_HORIZONTAL,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // back home button
                      CoreLabelIconBtn(
                        icon: Icons.close_rounded,
                        color: themeData.colorPalette.onPrimary,
                        iconColor: themeData.colorPalette.primary,
                        callback: () {
                          FocusScope.of(context).unfocus();
                          context
                              .read<ApplicationBloc>()
                              .add(ApplicationEventChangePageIndex(index: 0));
                        },
                      ),
                      // new chat button
                      CoreLabelBtn(
                        name: 'New',
                        color: themeData.colorPalette.onPrimary,
                        textColor: themeData.colorPalette.primary,
                        callback: () {},
                      )
                    ],
                  ),
                ),
                // ai animation
                Center(child: LottieBuilder.asset('assets/lottie/ai3.json')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
