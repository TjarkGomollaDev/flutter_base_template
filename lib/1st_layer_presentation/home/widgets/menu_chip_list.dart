import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/widgets/menu_chip.dart';
import 'package:flutter_base_template/app_constants.dart';

class MenuChipList extends StatelessWidget {
  static const List<String> chipsInfo = [
    'All',
    'Images',
    'Videos',
    'Finance',
    'News',
    'Sport',
  ];

  const MenuChipList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.LABEL_BTN_HEIGHT,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(chipsInfo.length, (index) {
          return MenuChip(
            name: chipsInfo[index],
            index: index,
          );
        }),
      ),
    );
  }
}
