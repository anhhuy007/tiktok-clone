import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';

class CustomTextStyles {
  static TextStyle headlineSmall = TextStyle(
    color: PrimaryColors.gray900,
    fontSize: 24.fsize,
    fontWeight: FontWeight.w700,
    fontFamily: "Urbanist"
  );

  static TextStyle labelMedium = TextStyle(
      color: ColorSchemes.primaryColorScheme.onErrorContainer,
      fontSize: 10.fsize,
      fontWeight: FontWeight.w600,
      fontFamily: "Urbanist"
  );

  static TextStyle titleLarge = TextStyle(
      color: PrimaryColors.gray900,
      fontSize: 20.fsize,
      fontWeight: FontWeight.w700,
      fontFamily: "Urbanist"
  );

  static TextStyle titleMedium = TextStyle(
      color: PrimaryColors.gray900,
      fontSize: 18.fsize,
      fontWeight: FontWeight.w700,
      fontFamily: "Urbanist"
  );

  static TextStyle titleSmall = TextStyle(
      color: PrimaryColors.gray700,
      fontSize: 14.fsize,
      fontWeight: FontWeight.w500,
      fontFamily: "Urbanist"
  );

  static TextStyle get titleMediumOnErrorContainerSemiBold => titleMedium.copyWith(
    color: ColorSchemes.primaryColorScheme.onErrorContainer,
    fontSize: 16.fsize,
    fontWeight: FontWeight.w600
  );

  static TextStyle get titleMediumPrimarySemiBold => titleMedium.copyWith(
      color: ColorSchemes.primaryColorScheme.primary,
      fontSize: 16.fsize,
      fontWeight: FontWeight.w600
  );

  static TextStyle get titleSmallErrorContainer => titleSmall.copyWith(
      color: ColorSchemes.primaryColorScheme.onErrorContainer
  );

  static TextStyle get titleSmallGray900 => titleSmall.copyWith(
      color: PrimaryColors.gray900
  );
}

class PrimaryColors {
  static Color get black900 => Color(0xFF000000);
  static Color get blueGray400 => Color(0xFF888888);
  static Color get gray500 => Color(0xFF9E9E9E);
  static Color get gray700 => Color(0xFF616161);
  static Color get gray900 => Color(0xFF212121);
}

class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    primary: Color(0xFF181717),
    errorContainer: Color(0xFF424242),
    onErrorContainer: Color(0xFFFFFFFF)
  );
}