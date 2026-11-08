// Screaming snake case is used intentionally for global layout constants.
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:ui';

abstract class AppConstants {
  // #### RADII ####
  static const double RADIUS_XS = 4;
  static const double RADIUS_S = 8;
  static const double RADIUS_M = 12;
  static const double RADIUS_L = 14;
  static const double RADIUS_XL = 20;
  static const double RADIUS_XXL = 30;

  // #### VERTICAL SPACING ####
  static const double SPACE_VERTICAL_XXS = 4;
  static const double SPACE_VERTICAL_XS = 8;
  static const double SPACE_VERTICAL_S = 16;
  static const double SPACE_VERTICAL_M = 20;
  static const double SPACE_VERTICAL_L = 24;
  static const double SPACE_VERTICAL_XL = 30;
  static const double SPACE_VERTICAL_XXL = 40;

  // #### HORIZONTAL SPACING ####
  static const double SPACE_HORIZONTAL_XS = 6;
  static const double SPACE_HORIZONTAL_S = 10;
  static const double SPACE_HORIZONTAL_M = 16;
  static const double SPACE_HORIZONTAL_L = 20;
  static const double SPACE_HORIZONTAL_XL = 30;

  // #### COMPONENT HEIGHTS ####
  static const double BTN_HEIGHT = 52;
  static const double LABEL_BTN_HEIGHT = 32;
  static const double NAV_BAR_BTN_HEIGHT = 62;

  // #### ICON SIZES ####
  static const double INPUT_FIELD_ICON_SIZE = 26;
  static const double TILE_ICON_SIZE = 26;
  static const double TILE_ICON_ARROW_SIZE = 16;
  static const double SMALL_ICON_SIZE = 20;
  static const double NAV_BAR_ICON_SIZE = 22;

  // #### LAYOUT & EFFECTS ####
  static const double PAGE_PADDING_HORIZONTAL = 20;
  static const double SAFE_AREA_MIN_PADDING_BTM = 10;
  static const double CURSOR_HEIGHT = 20;

  static final ImageFilter BLUR_FILTER = ImageFilter.blur(
    sigmaX: 10,
    sigmaY: 12,
  );
}
