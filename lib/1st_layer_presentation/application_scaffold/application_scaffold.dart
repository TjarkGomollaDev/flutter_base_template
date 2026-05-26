import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';
import 'package:flutter_base_template/l10n/app_localizations.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorPalette = Theme.of(context).colorPalette;
    final l10n = AppLocalizations.of(context)!;

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
              icon: const Icon(Icons.home), label: l10n.home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.search), label: l10n.page2),
          BottomNavigationBarItem(
              icon: const Icon(Icons.favorite), label: l10n.page3),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: l10n.page4),
        ],
      ),
    );
  }
}
