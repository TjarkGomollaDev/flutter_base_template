import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_divider.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_settings_tile_switch.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_settings_tile.dart';
import 'package:flutter_base_template/2nd_layer_application/application/home_bloc/home_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class CardSettings extends StatelessWidget {
  const CardSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
      child: Column(
        children: List.generate(
          cardSettingsData.length,
          (index) {
            final item = cardSettingsData[index];
            return Column(
              children: [
                if (index == 0) CoreDivider(),
                if (item['switch'] as bool == true)
                  CoreSettingsTileSwitch(
                    name: item['name'] as String,
                    text: item['text'] as String,
                    icon: item['icon'] as IconData,
                    blocBuilder: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        return Transform.scale(
                          scale: AppConstants.SWITCH_SCALE,
                          alignment: Alignment.centerRight,
                          child: Switch(
                            activeTrackColor: themeData.colorPalette.onPrimary,
                            activeThumbColor: themeData.colorPalette.primary,
                            inactiveThumbColor: themeData.colorPalette.onPrimary,
                            inactiveTrackColor: themeData.colorPalette.gray6,
                            value: state.cardStatus,
                            onChanged: (_) => context.read<HomeBloc>().add(HomeEventChangeCardStatus()),
                          ),
                        );
                      },
                    ),
                  )
                else
                  CoreSettingsTile(
                    name: item['name'] as String,
                    text: item['text'] as String,
                    icon: item['icon'] as IconData,
                    callback: () {},
                  ),
                CoreDivider(),
              ],
            );
          },
        ),
      ),
    );
  }
}

final cardSettingsData = [
  {
    'name': 'Card Status',
    'text': 'Enabled your card for payment',
    'icon': Icons.credit_card,
    'switch': true,
  },
  {
    'name': 'Upgrade your Card',
    'text': 'Get your card best upgrade',
    'icon': Icons.info_outline,
    'switch': false,
  },
  {
    'name': 'Card Details',
    'text': 'Organize all your information',
    'icon': Icons.settings,
    'switch': false,
  },
];
