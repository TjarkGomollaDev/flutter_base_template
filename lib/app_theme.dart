import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

abstract class AppTheme {
  // #### ALL COLORS ####
  static const white = Color.fromRGBO(255, 255, 255, 1);
  static const black = Color.fromRGBO(0, 0, 0, 1);
  static const transparent = Color.fromARGB(0, 0, 0, 0);

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

  // #### COLOR PALETTE ####
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

  // #### ALL SHADOWS ####
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

  // #### SHADOW PALETTE ####
  static final _shadowPaletteLight = ShadowPalette(
    containerShadow: _containerShadowLight,
    primaryBtnShadow: _primaryBtnShadowLight,
    onPrimaryBtnShadow: _onPrimaryBtnShadowLight,
  );

  static final _shadowPaletteDark = ShadowPalette(
    containerShadow: _containerShadowDark,
    primaryBtnShadow: _primaryBtnShadowDark,
    onPrimaryBtnShadow: _onPrimaryBtnShadowDark,
  );

  // #### ALL TEXT STYLES ####
  static const _displayLargeTextLight = TextStyle(
    color: black,
    fontSize: 60,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const _displayMediumTextLight = TextStyle(
    color: black,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const _displaySmallTextLight = TextStyle(
    color: black,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

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

  static final _displayLargeTextDark = _displayLargeTextLight.copyWith(
    color: white,
  );
  static final _displayMediumTextDark = _displayMediumTextLight.copyWith(
    color: white,
  );
  static final _displaySmallTextDark = _displaySmallTextLight.copyWith(
    color: white,
  );

  static final _titleLargeTextDark = _titleLargeTextLight.copyWith(
    color: white,
  );
  static final _titleMediumTextDark = _titleMediumTextLight.copyWith(
    color: white,
  );
  static final _titleSmallTextDark = _titleSmallTextLight.copyWith(
    color: white,
  );

  static final _bodyLargeTextDark = _bodyLargeTextLight.copyWith(color: white);
  static final _bodyMediumTextDark = _bodyMediumTextLight.copyWith(
    color: white,
  );
  static final _bodySmallTextDark = _bodySmallTextLight.copyWith(color: white);

  static final _labelLargeTextDark = _labelLargeTextLight.copyWith(
    color: white,
  );
  static final _labelMediumTextDark = _labelMediumTextLight.copyWith(
    color: white,
  );

  // #### TEXT THEMES ####
  static const _textThemeLight = TextTheme(
    displayMedium: _displayMediumTextLight,
    displayLarge: _displayLargeTextLight,
    displaySmall: _displaySmallTextLight,
    titleLarge: _titleLargeTextLight,
    titleMedium: _titleMediumTextLight,
    titleSmall: _titleSmallTextLight,
    bodyLarge: _bodyLargeTextLight,
    bodyMedium: _bodyMediumTextLight,
    bodySmall: _bodySmallTextLight,
    labelLarge: _labelLargeTextLight,
    labelMedium: _labelMediumTextLight,
  );

  static final _textThemeDark = TextTheme(
    displayLarge: _displayLargeTextDark,
    displayMedium: _displayMediumTextDark,
    displaySmall: _displaySmallTextDark,
    titleLarge: _titleLargeTextDark,
    titleMedium: _titleMediumTextDark,
    titleSmall: _titleSmallTextDark,
    bodyLarge: _bodyLargeTextDark,
    bodyMedium: _bodyMediumTextDark,
    bodySmall: _bodySmallTextDark,
    labelLarge: _labelLargeTextDark,
    labelMedium: _labelMediumTextDark,
  );

  // #### ALL BORDERS ####
  static final disabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.RADIUS_S),
    borderSide: const BorderSide(color: transparent),
  );

  static final disabledBorderRound = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.RADIUS_XXL),
    borderSide: const BorderSide(color: transparent),
  );

  static final errorBorderLight = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.RADIUS_S),
    borderSide: const BorderSide(color: redLight, width: 2),
  );

  static final errorBorderDark = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.RADIUS_S),
    borderSide: const BorderSide(color: redDark),
  );

  // #### INPUT DECORATION THEMES ####
  static final _inputDecorationThemeLight = InputDecorationTheme(
    filled: true,
    fillColor: grayLight6,
    isDense: true,
    border: disabledBorder,
    enabledBorder: disabledBorder,
    disabledBorder: disabledBorder,
    focusedBorder: disabledBorder,
    errorBorder: errorBorderLight,
    focusedErrorBorder: errorBorderLight,
    isCollapsed: true,
    hintStyle: _bodyLargeTextLight.copyWith(color: grayLight2),
    errorStyle: _bodySmallTextLight.copyWith(color: redLight),
    prefixIconColor: grayLight1,
    suffixIconColor: black,
    errorMaxLines: 2,
  );

  static final _inputDecorationThemeDark = InputDecorationTheme(
    filled: true,
    fillColor: grayDark6,
    border: disabledBorder,
    enabledBorder: disabledBorder,
    disabledBorder: disabledBorder,
    focusedBorder: disabledBorder,
    errorBorder: errorBorderDark,
    focusedErrorBorder: errorBorderDark,
    isCollapsed: true,
    hintStyle: _bodyLargeTextDark.copyWith(color: grayDark2),
    errorStyle: _bodySmallTextDark.copyWith(color: redDark),
    prefixIconColor: grayDark1,
    suffixIconColor: white,
    errorMaxLines: 2,
  );

  // #### TEXT SELECTION THEMES ####
  static const _textSelectionThemeLight = TextSelectionThemeData(
    cursorColor: black,
  );

  static const _textSelectionThemeDark = TextSelectionThemeData(
    cursorColor: white,
  );

  // #### BOTTOM SHEET THEMES ####
  static const _bottomSheetThemeLight = BottomSheetThemeData(
    backgroundColor: white,
    showDragHandle: true,
    dragHandleColor: grayLight1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppConstants.RADIUS_XL),
      ),
    ),
  );

  static final _bottomSheetThemeDark = _bottomSheetThemeLight.copyWith(
    backgroundColor: black,
    dragHandleColor: grayDark1,
  );

  // #### SWITCH THEMES ####
  static const _switchThemeLight = SwitchThemeData(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static const _switchThemeDark = _switchThemeLight;

  // #### APP THEMES ####
  static final appThemeLight = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    inputDecorationTheme: _inputDecorationThemeLight,
    textSelectionTheme: _textSelectionThemeLight,
    textTheme: _textThemeLight,
    scaffoldBackgroundColor: white,
    appBarTheme: const AppBarTheme(backgroundColor: white),
    bottomSheetTheme: _bottomSheetThemeLight,
    switchTheme: _switchThemeLight,
    // Disables Material ink ripples to match the custom flat button style.
    splashFactory: NoSplash.splashFactory,
    splashColor: transparent,
    highlightColor: transparent,
    hoverColor: transparent,
    extensions: [_colorPaletteLight, _shadowPaletteLight],
  );

  static final appThemeDark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    inputDecorationTheme: _inputDecorationThemeDark,
    textSelectionTheme: _textSelectionThemeDark,
    textTheme: _textThemeDark,
    scaffoldBackgroundColor: black,
    appBarTheme: const AppBarTheme(backgroundColor: black),
    bottomSheetTheme: _bottomSheetThemeDark,
    switchTheme: _switchThemeDark,
    // Disables Material ink ripples to match the custom flat button style.
    splashFactory: NoSplash.splashFactory,
    splashColor: transparent,
    highlightColor: transparent,
    hoverColor: transparent,
    extensions: [_colorPaletteDark, _shadowPaletteDark],
  );
}
