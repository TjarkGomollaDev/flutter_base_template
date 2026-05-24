import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_divider.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_settings_tile.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_settings_tile_info.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_settings_tile_switch.dart';
import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Column(
      children: [
        CoreDivider(),
        // use systeme theme
        CoreSettingsTileSwitch(
          name: 'Use System Theme',
          text: 'Theme is same as your system',
          icon: Icons.light_mode_outlined,
          blocBuilder: BlocBuilder<ThemeBloc, ThemeState>(
            buildWhen: (previous, current) => previous.useSystemTheme != current.useSystemTheme,
            builder: (context, state) {
              return Transform.scale(
                scale: AppConstants.SWITCH_SCALE,
                alignment: Alignment.centerRight,
                child: Switch(
                  activeTrackColor: themeData.colorPalette.onPrimary,
                  activeThumbColor: themeData.colorPalette.primary,
                  inactiveThumbColor: themeData.colorPalette.onPrimary,
                  inactiveTrackColor: themeData.colorPalette.gray6,
                  value: state.useSystemTheme,
                  onChanged: (_) => context.read<ThemeBloc>().add(ThemeEventChangeUseSystemTheme()),
                ),
              );
            },
          ),
        ),
        CoreDivider(),
        // theme mode
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            if (!state.useSystemTheme) {
              return CoreSettingsTileSwitch(
                name: 'Change Thememode',
                text: 'Your current theme is ${state.themeMode ? 'light' : 'dark'}',
                icon: Icons.brightness_4_outlined,
                blocBuilder: BlocBuilder<ThemeBloc, ThemeState>(
                  buildWhen: (previous, current) => previous.themeMode != current.themeMode,
                  builder: (context, state) {
                    return Transform.scale(
                      scale: AppConstants.SWITCH_SCALE,
                      alignment: Alignment.centerRight,
                      child: Switch(
                        activeTrackColor: themeData.colorPalette.onPrimary,
                        activeThumbColor: themeData.colorPalette.primary,
                        inactiveThumbColor: themeData.colorPalette.onPrimary,
                        inactiveTrackColor: themeData.colorPalette.gray6,
                        value: state.themeMode,
                        onChanged: (_) => context.read<ThemeBloc>().add(ThemeEventChangeThemeMode()),
                      ),
                    );
                  },
                ),
              );
            }
            return SizedBox();
          },
        ),
        if (!context.read<ThemeBloc>().state.useSystemTheme) CoreDivider(),
        // settings
        CoreSettingsTile(name: 'Security & Privacy', text: 'Manage your passwords', callback: () {}, icon: Icons.lock_outline),
        CoreDivider(),
        CoreSettingsTile(name: 'Personal Data', text: 'All information about you', callback: () {}, icon: Icons.person_outline),
        CoreDivider(),
        CoreSettingsTile(name: 'Storage & Data', text: 'Save your data in the cloud', callback: () {}, icon: Icons.cloud_outlined),
        CoreDivider(),
        CoreSettingsTile(
            name: 'Notifications', text: 'Manage custom notifications', callback: () {}, icon: Icons.notifications_none_rounded),

        CoreDivider(),
        CoreSettingsTile(name: 'Help', text: 'Visit our customer center', callback: () {}, icon: Icons.info_outline),
        CoreDivider(),
        CoreSettingsTileInfo(name: 'Version 1.5.2', text: 'Made with Love in Münster', icon: MdiIcons.heartOutline),
        CoreDivider(),
      ],
    );
  }
}
