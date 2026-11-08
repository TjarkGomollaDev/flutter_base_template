import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:go_router/go_router.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorPalette = context.colorPalette;
    final l10n = context.l10n;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorPalette.primary,
        selectedItemColor: colorPalette.blue,
        unselectedItemColor: colorPalette.gray1,
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home, key: Key('nav_tab_home')),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search, key: Key('nav_tab_page_2')),
            label: l10n.page2,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite, key: Key('nav_tab_page_3')),
            label: l10n.page3,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person, key: Key('nav_tab_page_4')),
            label: l10n.page4,
          ),
        ],
      ),
    );
  }
}
