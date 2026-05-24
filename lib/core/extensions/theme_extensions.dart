import 'package:flutter/material.dart';

// color palette
class ColorPalette extends ThemeExtension<ColorPalette> {
  final Color primary;
  final Color onPrimary;
  final Color transparent;
  final Color error;
  final Color success;
  final Color blue;
  final Color mint;
  final Color gray1;
  final Color gray2;
  final Color gray3;
  final Color gray4;
  final Color gray5;
  final Color gray6;

  ColorPalette({
    required this.primary,
    required this.onPrimary,
    required this.transparent,
    required this.error,
    required this.success,
    required this.blue,
    required this.mint,
    required this.gray1,
    required this.gray2,
    required this.gray3,
    required this.gray4,
    required this.gray5,
    required this.gray6,
  });

  @override
  ColorPalette copyWith({
    Color? primary,
    Color? onPrimary,
    Color? transparent,
    Color? error,
    Color? success,
    Color? blue,
    Color? mint,
    Color? gray1,
    Color? gray2,
    Color? gray3,
    Color? gray4,
    Color? gray5,
    Color? gray6,
  }) {
    return ColorPalette(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      transparent: transparent ?? this.transparent,
      error: error ?? this.error,
      success: success ?? this.success,
      blue: blue ?? this.blue,
      mint: mint ?? this.mint,
      gray1: gray1 ?? this.gray1,
      gray2: gray2 ?? this.gray2,
      gray3: gray3 ?? this.gray3,
      gray4: gray4 ?? this.gray4,
      gray5: gray5 ?? this.gray5,
      gray6: gray6 ?? this.gray6,
    );
  }

  @override
  ThemeExtension<ColorPalette> lerp(
    covariant ThemeExtension<ColorPalette>? other,
    double t,
  ) {
    if (other is! ColorPalette) {
      return this;
    }
    return ColorPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      gray1: Color.lerp(gray1, other.gray1, t)!,
      gray2: Color.lerp(gray2, other.gray2, t)!,
      gray3: Color.lerp(gray3, other.gray3, t)!,
      gray4: Color.lerp(gray4, other.gray4, t)!,
      gray5: Color.lerp(gray5, other.gray5, t)!,
      gray6: Color.lerp(gray6, other.gray6, t)!,
    );
  }
}

// shadow palette
class ShadowPalette extends ThemeExtension<ShadowPalette> {
  final BoxShadow containerShadow;
  final BoxShadow primaryBtnShadow;
  final BoxShadow onPrimaryBtnShadow;

  ShadowPalette({
    required this.containerShadow,
    required this.primaryBtnShadow,
    required this.onPrimaryBtnShadow,
  });

  @override
  ThemeExtension<ShadowPalette> copyWith({
    BoxShadow? containerShadow,
    BoxShadow? primaryBtnShadow,
    BoxShadow? onPrimaryBtnShadow,
  }) {
    return ShadowPalette(
      containerShadow: containerShadow ?? this.containerShadow,
      primaryBtnShadow: primaryBtnShadow ?? this.primaryBtnShadow,
      onPrimaryBtnShadow: onPrimaryBtnShadow ?? this.onPrimaryBtnShadow,
    );
  }

  @override
  ThemeExtension<ShadowPalette> lerp(
    covariant ThemeExtension<ShadowPalette>? other,
    double t,
  ) {
    if (other is! ShadowPalette) {
      return this;
    }
    return ShadowPalette(
      containerShadow: BoxShadow.lerp(containerShadow, other.containerShadow, t)!,
      primaryBtnShadow: BoxShadow.lerp(primaryBtnShadow, other.primaryBtnShadow, t)!,
      onPrimaryBtnShadow: BoxShadow.lerp(onPrimaryBtnShadow, other.onPrimaryBtnShadow, t)!,
    );
  }
}

// getter
extension ThemeDataExtensions on ThemeData {
  ColorPalette get colorPalette => extension<ColorPalette>()!;
  ShadowPalette get shadowPalette => extension<ShadowPalette>()!;
}
