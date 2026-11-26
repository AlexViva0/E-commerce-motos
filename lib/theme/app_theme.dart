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
      cardColor: Colors.white,
      dividerColor: blackColor10,
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
        onSurfaceVariant: blackColor60,
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: Color(0xFFF9FAFB),
        surfaceContainer: lightGreyColor,
        surfaceContainerHigh: Color(0xFFECEEF2),
        surfaceContainerHighest: Color(0xFFE3E6EC),
        outline: blackColor10,
        outlineVariant: blackColor5,
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
      segmentedButtonTheme: segmentedButtonTheme(
        selectedBackground: primaryColor,
        selectedForeground: Colors.white,
        unselectedForeground: blackColor,
        borderColor: blackColor10,
      ),
      inputDecorationTheme: lightInputDecorationTheme,
      checkboxTheme: checkboxThemeData.copyWith(
        side: const BorderSide(color: blackColor40, width: 1.5),
      ),
      chipTheme: chipLightThemeData,
      cardTheme: cardLightThemeData,
      listTileTheme: listTileLightThemeData,
      bottomSheetTheme: bottomSheetLightThemeData,
      switchTheme: switchLightThemeData,
      radioTheme: radioLightThemeData,
      snackBarTheme: snackBarLightThemeData,
      appBarTheme: appBarLightTheme,
      bottomNavigationBarTheme: bottomNavigationBarLightTheme,
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
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Plus Jakarta",
      primarySwatch: primaryMaterialColor,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkSurfaceColor,
      dividerColor: darkBorderColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFF4A180D),
        onPrimaryContainer: Color(0xFFFAD0C7),
        secondary: accentColor,
        onSecondary: blackColor,
        secondaryContainer: Color(0xFF4D3404),
        onSecondaryContainer: Color(0xFFFFE5AE),
        surface: darkSurfaceColor,
        onSurface: darkTextPrimary,
        onSurfaceVariant: darkTextSecondary,
        surfaceContainerLowest: darkBackgroundColor,
        surfaceContainerLow: Color(0xFF14161B),
        surfaceContainer: darkSurfaceColor,
        surfaceContainerHigh: Color(0xFF22252C),
        surfaceContainerHighest: Color(0xFF2A2E37),
        outline: darkBorderColor,
        outlineVariant: Color(0xFF22252D),
        error: errorColor,
        onError: Colors.white,
      ),
      iconTheme: const IconThemeData(color: darkTextPrimary),
      textTheme: _buildTextTheme(
        primaryTextColor: darkTextPrimary,
        secondaryTextColor: darkTextSecondary,
        mutedTextColor: darkTextMuted,
      ),
      elevatedButtonTheme: elevatedButtonTheme(
        disabledBackgroundColor: const Color(0xFF282B34),
        disabledForegroundColor: darkTextMuted,
      ),
      filledButtonTheme: filledButtonTheme(
        disabledBackgroundColor: const Color(0xFF282B34),
        disabledForegroundColor: darkTextMuted,
      ),
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(
        borderColor: darkBorderColor,
        foregroundColor: darkTextPrimary,
      ),
      segmentedButtonTheme: segmentedButtonTheme(
        selectedBackground: primaryColor,
        selectedForeground: Colors.white,
        unselectedForeground: darkTextSecondary,
        borderColor: darkBorderColor,
      ),
      inputDecorationTheme: darkInputDecorationTheme,
      checkboxTheme: checkboxThemeData.copyWith(
        side: const BorderSide(color: darkTextMuted, width: 1.5),
      ),
      chipTheme: chipDarkThemeData,
      cardTheme: cardDarkThemeData,
      listTileTheme: listTileDarkThemeData,
      bottomSheetTheme: bottomSheetDarkThemeData,
      switchTheme: switchDarkThemeData,
      radioTheme: radioDarkThemeData,
      snackBarTheme: snackBarDarkThemeData,
      appBarTheme: appBarDarkTheme,
      bottomNavigationBarTheme: bottomNavigationBarDarkTheme,
      dividerTheme:
          const DividerThemeData(color: darkBorderColor, thickness: 1),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      scrollbarTheme: scrollbarDarkThemeData,
      dataTableTheme: dataTableDarkThemeData,
    );
  }
}
