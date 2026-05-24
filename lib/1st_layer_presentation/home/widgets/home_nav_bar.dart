import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/widgets/home_nav_bar_item.dart';
import 'package:flutter_base_template/2nd_layer_application/application/application_bloc/application_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(bottom: AppConstants.SAFE_AREA_MIN_PADDING_BTM),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
        child: Row(
          children: [
            HomeNavBarItem(
              name: 'Chats',
              iconAsset: 'assets/icons/chat.png',
              callback: () {},
            ),
            AppConstants.SPACE_HORIZONTAL_S.widthSizedBox,
            HomeNavBarItem(
              name: 'Assistent',
              iconAsset: 'assets/icons/chat-gpt.png',
              callback: () {
                context.read<ApplicationBloc>().add(ApplicationEventChangePageIndex(index: 1));
              },
            ),
          ],
        ),
      ),
    );
  }
}
