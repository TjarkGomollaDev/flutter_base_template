import 'package:flutter/material.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_theme.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';

class SettingsGroup extends StatelessWidget {
  final List<Map<String, Object>> groupOfSettings;

  const SettingsGroup({
    super.key,
    required this.groupOfSettings,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Column(
      // group of settings
      children: List.generate(
        groupOfSettings.length,
        (index) {
          final item = groupOfSettings[index];
          final isFirstItemInGroup = index == 0;
          final isLastItemInGroup = index == groupOfSettings.length - 1;
          return Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/settings_${item['name'].toString().toLowerCase()}',
                ),
                child: Container(
                  height: AppConstants.BTN_HEIGHT,
                  decoration: BoxDecoration(
                      //color: AppTheme.grayLight5,
                      // borderRadius: BorderRadius.vertical(
                      //   top: isFirstItemInGroup
                      //       ? const Radius.circular(AppConstants.RADIUS_L)
                      //       : Radius.zero,
                      //   bottom: isLastItemInGroup
                      //       ? const Radius.circular(AppConstants.RADIUS_L)
                      //       : Radius.zero,
                      // ),
                      ),
                  child: Center(
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: AppConstants.SPACE_HORIZONTAL_L,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
                      // icon
                      leading: Container(
                        height: AppConstants.LABEL_BTN_HEIGHT + 0,
                        width: AppConstants.LABEL_BTN_HEIGHT + 0,
                        decoration: BoxDecoration(
                          color: AppTheme.black,
                          borderRadius: BorderRadius.circular(AppConstants.RADIUS_S),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          size: 30,
                          color: AppTheme.white,
                        ),
                      ),
                      // title
                      title: Text(
                        item['name'] as String,
                        style: themeData.textTheme.bodyMedium,
                      ),
                      // arrow icon to show that the container is clickable
                      trailing: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                        color: AppTheme.grayLight2,
                      ),
                    ),
                  ),
                ),
              ),
              // // divider between two settings
              // if (!isLastItemInGroup)
              //   Positioned(
              //     // divider starts at the same horizontal position as the title
              //     left:
              //         AppConstants.SPACE_HORIZONTAL_L * 2 + AppConstants.ICON_CONTAINER_SIZE.width,
              //     right: 0,
              //     bottom: 0,
              //     child: Divider(
              //       height: 0,
              //       color: themeData.colorScheme.secondaryContainer,
              //     ),
              //   ),
            ],
          );
        },
      ),
    );
  }
}
