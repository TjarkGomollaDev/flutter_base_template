import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

abstract class AppTheme {
  // #### ALL COLORS ###########################################
  // Black, White and Transparent
  static const white = Color.fromRGBO(255, 255, 255, 1);
  static const black = Color.fromRGBO(0, 0, 0, 1);
  static const transparent = Color.fromARGB(0, 0, 0, 0);

  // Colors -> LIGHT
  static const grayLight1 = Color.fromRGBO(126, 125, 130, 1);
  static const grayLight2 = Color.fromRGBO(174, 174, 178, 1);
  static const grayLight3 = Color.fromRGBO(199, 199, 204, 1);
  static const grayLight4 = Color.fromRGBO(209, 209, 234, 1);
  static const grayLight5 = Color.fromRGBO(229, 229, 234, 1);
  static const grayLight6 = Color.fromRGBO(242, 242, 247, 1);
  static const blueLight = Color.fromRGBO(0, 122, 255, 1);
  static const redLight = Color.fromRGBO(255, 59, 48, 1);
  static const greenLight = Color.fromRGBO(52, 199, 89, 1);
  static const mintLight = Color.fromRGBO(0, 199, 190, 1);

  // Colors -> DARK
  static const grayDark1 = Color.fromRGBO(142, 142, 147, 1);
  static const grayDark2 = Color.fromRGBO(99, 99, 102, 1);
  static const grayDark3 = Color.fromRGBO(72, 72, 74, 1);
  static const grayDark4 = Color.fromRGBO(58, 58, 60, 1);
  static const grayDark5 = Color.fromRGBO(44, 44, 46, 1);
  static const grayDark6 = Color.fromRGBO(28, 28, 30, 1);
  static const blueDark = Color.fromRGBO(10, 132, 255, 1);
  static const redDark = Color.fromRGBO(255, 69, 58, 1);
  static const greenDark = Color.fromRGBO(48, 209, 88, 1);
  static const mintDark = Color.fromRGBO(99, 230, 226, 1);

  // #### COLOR PALETTE ########################################
  // Color Palette -> LIGHT
  static final _colorPaletteLight = ColorPalette(
    primary: white,
    onPrimary: black,
    transparent: transparent,
    error: redLight,
    success: greenLight,
    blue: blueLight,
    mint: mintLight,
    gray1: grayLight1,
    gray2: grayLight2,
    gray3: grayLight3,
    gray4: grayLight4,
    gray5: grayLight5,
    gray6: grayLight6,
  );

  // Color Palette -> DARK
  static final _colorPaletteDark = ColorPalette(
    primary: black,
    onPrimary: white,
    transparent: transparent,
    error: redDark,
    success: greenDark,
    blue: blueDark,
    mint: mintDark,
    gray1: grayDark1,
    gray2: grayDark2,
    gray3: grayDark3,
    gray4: grayDark4,
    gray5: grayDark5,
    gray6: grayDark6,
  );

  // #### ALL SHADOWS ##########################################
  // Shadows -> LIGHT
  static final _containerShadowLight = BoxShadow(
    blurRadius: 6,
    spreadRadius: 2,
    color: grayLight3.withAlpha(102),
  );

  static final _primaryBtnShadowLight = BoxShadow(
    blurRadius: 4,
    spreadRadius: 1,
    color: grayLight3.withAlpha(102),
  );

  static final _onPrimaryBtnShadowLight = BoxShadow(
    blurRadius: 4,
    spreadRadius: 1,
    color: grayLight1.withAlpha(102),
  );

  // Shadows -> DARK
  static final _containerShadowDark = BoxShadow(
    blurRadius: 6,
    spreadRadius: 2,
    color: grayDark3.withAlpha(102),
  );

  static final _primaryBtnShadowDark = BoxShadow(
    blurRadius: 4,
    spreadRadius: 1,
    color: grayDark3.withAlpha(102),
  );

  static final _onPrimaryBtnShadowDark = BoxShadow(
    blurRadius: 4,
    spreadRadius: 1,
    color: grayDark1.withAlpha(102),
  );

  // #### SHADOW PALETTE #######################################
  // Shadow Palette -> LIGHT
  static final _shadowPaletteLight = ShadowPalette(
    containerShadow: _containerShadowLight,
    primaryBtnShadow: _primaryBtnShadowLight,
    onPrimaryBtnShadow: _onPrimaryBtnShadowLight,
  );

  // Shadow Palette -> Dark
  static final _shadowPaletteDark = ShadowPalette(
      containerShadow: _containerShadowDark, primaryBtnShadow: _primaryBtnShadowDark, onPrimaryBtnShadow: _onPrimaryBtnShadowDark);

  // #### ALL TEXT STYLES ######################################
  // Text Styles -> LIGHT
  // display
  static const _displayLargeTextLight = TextStyle(
    fontFamily: 'Poppins',
    color: black,
    fontSize: 60,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const _displayMediumTextLight = TextStyle(
    fontFamily: 'Poppins',
    color: black,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const _displaySmallTextLight = TextStyle(
    fontFamily: 'Poppins',
    color: black,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // title
  static const _titleLargeTextLight = TextStyle(
    color: black,
    fontSize: 34,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.2,
    height: 1.2,
  );

  static const _titleMediumTextLight = TextStyle(
    color: black,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
    height: 1.2,
  );

  static const _titleSmallTextLight = TextStyle(
    color: black,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // body
  static const _bodyLargeTextLight = TextStyle(
    color: black,
    fontSize: 17,
    letterSpacing: -0.5,
    height: 1.4,
  );

  static const _bodyMediumTextLight = TextStyle(
    color: black,
    fontSize: 15,
    letterSpacing: -0.5,
    height: 1.4,
  );

  static const _bodySmallTextLight = TextStyle(
    color: black,
    fontSize: 13,
    letterSpacing: -0.5,
    height: 1.4,
  );

  // label
  static const _labelLargeTextLight = TextStyle(
    color: black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.4,
  );

  static const _labelMediumTextLight = TextStyle(
    color: black,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.4,
  );

  // Text Styles -> DARK
  // display
  static final _displayLargeTextDark = _displayLargeTextLight.copyWith(color: white);
  static final _displayMediumTextDark = _displayMediumTextLight.copyWith(color: white);
  static final _displaySmallTextDark = _displaySmallTextLight.copyWith(color: white);

  // title
  static final _titleLargeTextDark = _titleLargeTextLight.copyWith(color: white);
  static final _titleMediumTextDark = _titleMediumTextLight.copyWith(color: white);
  static final _titleSmallTextDark = _titleSmallTextLight.copyWith(color: white);

  // body
  static final _bodyLargeTextDark = _bodyLargeTextLight.copyWith(color: white);
  static final _bodyMediumTextDark = _bodyMediumTextLight.copyWith(color: white);
  static final _bodySmallTextDark = _bodySmallTextLight.copyWith(color: white);

  // label
  static final _labelLargeTextDark = _labelLargeTextLight.copyWith(color: white);
  static final _labelMediumTextDark = _labelMediumTextLight.copyWith(color: white);

  // #### TEXT THEMES ##########################################
  // Text Theme -> LIGHT
  static const _textThemeLight = TextTheme(
    // display
    displayMedium: _displayMediumTextLight,
    displayLarge: _displayLargeTextLight,
    displaySmall: _displaySmallTextLight,
    // title
    titleLarge: _titleLargeTextLight,
    titleMedium: _titleMediumTextLight,
    titleSmall: _titleSmallTextLight,
    // body
    bodyLarge: _bodyLargeTextLight,
    bodyMedium: _bodyMediumTextLight,
    bodySmall: _bodySmallTextLight,
    // label
    labelLarge: _labelLargeTextLight,
    labelMedium: _labelMediumTextLight,
  );

  // Text Theme -> DARK
  static final _textThemeDark = TextTheme(
    // display
    displayLarge: _displayLargeTextDark,
    displayMedium: _displayMediumTextDark,
    displaySmall: _displaySmallTextDark,
    // title
    titleLarge: _titleLargeTextDark,
    titleMedium: _titleMediumTextDark,
    titleSmall: _titleSmallTextDark,
    // body
    bodyLarge: _bodyLargeTextDark,
    bodyMedium: _bodyMediumTextDark,
    bodySmall: _bodySmallTextDark,
    // label
    labelLarge: _labelLargeTextDark,
    labelMedium: _labelMediumTextDark,
  );

  // #### ALL BORDERS ##########################################
  // Transparent Border
  static final disabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.RADIUS_S),
    borderSide: const BorderSide(color: transparent),
  );

  static final disabledBorderRound = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.RADIUS_XXL),
    borderSide: const BorderSide(color: transparent),
  );

  // Borders -> LIGHT
  static final errorBorderLight = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.RADIUS_S),
    borderSide: const BorderSide(color: redLight, width: 2),
  );

  // Borders -> DARK
  static final errorBorderDark = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.RADIUS_S),
    borderSide: const BorderSide(color: redDark),
  );

  // #### INPUT DECORATION THEMES ##############################
  // Input Decoration Theme -> LIGHT
  static final _inputDecorationThemeLight = InputDecorationTheme(
    // color
    filled: true,
    fillColor: grayLight6, isDense: true,
    // borders
    border: disabledBorder,
    enabledBorder: disabledBorder,
    disabledBorder: disabledBorder,
    focusedBorder: disabledBorder,
    errorBorder: errorBorderLight,
    focusedErrorBorder: errorBorderLight,
    // content
    isCollapsed: true,
    hintStyle: _bodyLargeTextLight.copyWith(color: grayLight2),
    errorStyle: _bodySmallTextLight.copyWith(color: redLight),
    prefixIconColor: grayLight1,
    suffixIconColor: black,
    errorMaxLines: 2,
  );

  // Input Decoration Theme -> DARK
  static final _inputDecorationThemeDark = InputDecorationTheme(
    // color
    filled: true,
    fillColor: grayDark6,
    // borders
    border: disabledBorder,
    enabledBorder: disabledBorder,
    disabledBorder: disabledBorder,
    focusedBorder: disabledBorder,
    errorBorder: errorBorderDark,
    focusedErrorBorder: errorBorderDark,
    // content
    isCollapsed: true,
    hintStyle: _bodyLargeTextLight.copyWith(color: grayDark2),
    errorStyle: _bodySmallTextLight.copyWith(color: redDark),
    prefixIconColor: grayDark1,
    suffixIconColor: white,
    errorMaxLines: 2,
  );

  // #### TEXT SELECTION THEMES ##################################
  // Text Selection Theme -> LIGHT
  static final _textSelectionThemeLight = TextSelectionThemeData(
    cursorColor: black,
  );

  // Text Selection Theme -> DARK
  static final _textSelectionThemeDark = TextSelectionThemeData(
    cursorColor: white,
  );

  // #### BOTTOM SHEET THEMES ##################################
  // Bottom Sheet Theme -> LIGHT
  static const _bottomSheetThemeLight = BottomSheetThemeData(
    backgroundColor: white,
    showDragHandle: true,
    dragHandleColor: grayLight1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.RADIUS_XL)),
    ),
  );

  // Bottom Sheet Theme -> DARK
  static final _bottomSheetThemeDark = _bottomSheetThemeLight.copyWith(
    backgroundColor: black,
    dragHandleColor: grayDark1,
  );

  // #### SWITCH THEMES ##################################
  // Switch Theme -> LIGHT
  static const _switchThemeLight = SwitchThemeData(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  // Switch Theme -> DARK
  static final _switchThemeDark = _switchThemeLight;

  // #### APP THEMES ###########################################
  // App Theme -> LIGHT
  static final appThemeLight = ThemeData(
    brightness: Brightness.light, // set this parameter to get the current ThemeMode in the app
    useMaterial3: true,
    inputDecorationTheme: _inputDecorationThemeLight,
    textSelectionTheme: _textSelectionThemeLight,
    textTheme: _textThemeLight,
    scaffoldBackgroundColor: white,
    appBarTheme: const AppBarTheme(backgroundColor: white),
    bottomSheetTheme: _bottomSheetThemeLight,
    switchTheme: _switchThemeLight,
    splashColor: transparent, // deactivates the material button splash effect
    highlightColor: transparent, // deactivates the material button splash effect
    hoverColor: transparent, // deactivates the material button splash effect
    extensions: [_colorPaletteLight, _shadowPaletteLight], // custom
  );

  // App Theme -> DARK
  static final appThemeDark = ThemeData(
    brightness: Brightness.dark, // set this parameter to get the current ThemeMode in the app
    useMaterial3: true,
    inputDecorationTheme: _inputDecorationThemeDark,
    textSelectionTheme: _textSelectionThemeDark,
    textTheme: _textThemeDark,
    scaffoldBackgroundColor: black,
    appBarTheme: const AppBarTheme(backgroundColor: black),
    bottomSheetTheme: _bottomSheetThemeDark,
    switchTheme: _switchThemeDark,
    splashColor: transparent, // deactivates the material button splash effect
    highlightColor: transparent, // deactivates the material button splash effect
    hoverColor: transparent, // deactivates the material button splash effect
    extensions: [_colorPaletteDark, _shadowPaletteDark], // custom
  );
}
