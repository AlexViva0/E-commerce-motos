import 'package:flutter/material.dart';
import 'package:shop/theme/button_theme.dart';
import 'package:shop/theme/input_decoration_theme.dart';

import '../constants.dart';
import 'checkbox_themedata.dart';
import 'theme_data.dart';

class AppTheme {
  static TextTheme _buildTextTheme({
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color mutedTextColor,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: grandisExtendedFont,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
      displayMedium: TextStyle(
        fontFamily: grandisExtendedFont,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
      displaySmall: TextStyle(
        fontFamily: grandisExtendedFont,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: grandisExtendedFont,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: grandisExtendedFont,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: grandisExtendedFont,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
      titleLarge: TextStyle(
        fontFamily: "Plus Jakarta",
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
      titleMedium: TextStyle(
        fontFamily: "Plus Jakarta",
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      titleSmall: TextStyle(
        fontFamily: "Plus Jakarta",
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Plus Jakarta",
        color: primaryTextColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Plus Jakarta",
        color: secondaryTextColor,
      ),
      bodySmall: TextStyle(
        fontFamily: "Plus Jakarta",
        color: mutedTextColor,
      ),
      labelLarge: TextStyle(
        fontFamily: "Plus Jakarta",
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      labelMedium: TextStyle(
        fontFamily: "Plus Jakarta",
        fontWeight: FontWeight.w600,
        color: secondaryTextColor,
      ),
      labelSmall: TextStyle(
        fontFamily: "Plus Jakarta",
        fontWeight: FontWeight.w500,
        color: mutedTextColor,
      ),
    );
  }

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: "Plus Jakarta",
      primarySwatch: primaryMaterialColor,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFFDECE8),
        onPrimaryContainer: primaryDarkColor,
        secondary: accentColor,
        onSecondary: blackColor,
        secondaryContainer: Color(0xFFFFF3D6),
        onSecondaryContainer: blackColor,
        surface: Colors.white,
        onSurface: blackColor,
        outline: blackColor10,
        error: errorColor,
        onError: Colors.white,
      ),
      iconTheme: const IconThemeData(color: blackColor),
      textTheme: _buildTextTheme(
        primaryTextColor: blackColor,
        secondaryTextColor: blackColor60,
        mutedTextColor: blackColor40,
      ),
      elevatedButtonTheme: elevatedButtonThemeData,
      filledButtonTheme: filledButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(),
      inputDecorationTheme: lightInputDecorationTheme,
      checkboxTheme: checkboxThemeData.copyWith(
        side: const BorderSide(color: blackColor40, width: 1.5),
      ),
      chipTheme: chipLightThemeData,
      appBarTheme: appBarLightTheme,
      dividerTheme: const DividerThemeData(color: blackColor10, thickness: 1),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      scrollbarTheme: scrollbarThemeData,
      dataTableTheme: dataTableLightThemeData,
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    const Color darkBackground = Color(0xFF0E0F12);
    const Color darkSurface = Color(0xFF1A1C21);

    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Plus Jakarta",
      primarySwatch: primaryMaterialColor,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFF4A180D),
        onPrimaryContainer: Color(0xFFFAD0C7),
        secondary: accentColor,
        onSecondary: blackColor,
        secondaryContainer: Color(0xFF4D3404),
        onSecondaryContainer: Color(0xFFFFE5AE),
        surface: darkSurface,
        onSurface: Colors.white,
        outline: whileColor20,
        error: errorColor,
        onError: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: _buildTextTheme(
        primaryTextColor: Colors.white,
        secondaryTextColor: whileColor60,
        mutedTextColor: whileColor40,
      ),
      elevatedButtonTheme: elevatedButtonThemeData,
      filledButtonTheme: filledButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(
        borderColor: whileColor20,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: darkInputDecorationTheme,
      checkboxTheme: checkboxThemeData.copyWith(
        side: const BorderSide(color: whileColor40, width: 1.5),
      ),
      chipTheme: chipDarkThemeData,
      appBarTheme: appBarDarkTheme,
      dividerTheme: const DividerThemeData(color: whileColor20, thickness: 1),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      scrollbarTheme: scrollbarThemeData,
      dataTableTheme: dataTableDarkThemeData,
    );
  }
}
