import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/widgets/weather_tile_metrics.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class WeatherTile extends StatelessWidget {
  const WeatherTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
      child: Container(
        decoration: BoxDecoration(
          color: themeData.colorPalette.gray6,
          borderRadius: BorderRadius.circular(AppConstants.RADIUS_L),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.SPACE_HORIZONTAL_L, vertical: AppConstants.SPACE_VERTICAL_S),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 15,
                          ),
                          AppConstants.SPACE_HORIZONTAL_XS.widthSizedBox,
                          Text(
                            'Chateauneuf-du-Pape',
                            style: themeData.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      AppConstants.SPACE_VERTICAL_S.heightSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '+17°',
                            style: themeData.textTheme.headlineLarge,
                          ),
                          AppConstants.SPACE_HORIZONTAL_L.widthSizedBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('H: 23°C'),
                              Text('L: 14°C'),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AppConstants.SPACE_HORIZONTAL_L),
                    child: Icon(
                      Icons.wb_sunny_sharp,
                      size: 55,
                    ),
                  )
                ],
              ),
              AppConstants.SPACE_VERTICAL_M.heightSizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherTileMetrics(name: 'Humidity', value: '30%'),
                  WeatherTileMetrics(name: 'Precipitation', value: '5.1 ml'),
                  WeatherTileMetrics(name: 'Pressure', value: '450 hPa'),
                  WeatherTileMetrics(name: 'Wind', value: '23 m/s'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
