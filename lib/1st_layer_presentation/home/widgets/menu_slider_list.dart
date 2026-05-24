import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/widgets/menu_slider.dart';

class MenuSliderList extends StatelessWidget {
  const MenuSliderList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(8, (index) {
          return MenuSlider(
            index: index,
            title: 'Chat smart',
            subtitle: 'more information',
            imagePath: 'assets/backgrounds/finance.jpg',
            icon: Icons.trending_up,
          );
        }),
      ),
    );
  }
}
