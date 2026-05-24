import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SliverAppBar(
      floating: true,
      pinned: true,
      surfaceTintColor: themeData.colorPalette.gray1,
      backgroundColor: themeData.colorPalette.primary,
      title: const Text('Home'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Action for settings
          },
        ),
      ],
    );
  }
}
