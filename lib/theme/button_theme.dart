import 'package:flutter/material.dart';

import '../constants.dart';

ElevatedButtonThemeData elevatedButtonTheme({
  Color disabledBackgroundColor = blackColor20,
  Color disabledForegroundColor = blackColor60,
}) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(defaultPadding),
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      elevation: 0,
      shadowColor: const Color(0x33E63E1C),
      minimumSize: const Size(double.infinity, 48),
      textStyle: const TextStyle(
        fontFamily: "Plus Jakarta",
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
    ),
  );
}

ElevatedButtonThemeData elevatedButtonThemeData = elevatedButtonTheme();

FilledButtonThemeData filledButtonTheme({
  Color disabledBackgroundColor = blackColor20,
  Color disabledForegroundColor = blackColor60,
}) {
  return FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.all(defaultPadding),
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      minimumSize: const Size(double.infinity, 48),
      textStyle: const TextStyle(
        fontFamily: "Plus Jakarta",
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
    ),
  );
}

FilledButtonThemeData filledButtonThemeData = filledButtonTheme();

OutlinedButtonThemeData outlinedButtonTheme({
  Color borderColor = blackColor10,
  Color foregroundColor = blackColor,
}) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(defaultPadding),
      foregroundColor: foregroundColor,
      minimumSize: const Size(double.infinity, 48),
      side: BorderSide(width: 1.5, color: borderColor),
      textStyle: const TextStyle(
        fontFamily: "Plus Jakarta",
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
    ),
  );
}

final textButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: primaryColor,
    textStyle: const TextStyle(
      fontFamily: "Plus Jakarta",
      fontWeight: FontWeight.w600,
    ),
  ),
);

SegmentedButtonThemeData segmentedButtonTheme({
  required Color selectedBackground,
  required Color selectedForeground,
  required Color unselectedForeground,
  required Color borderColor,
}) {
  return SegmentedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return selectedBackground;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return selectedForeground;
        }
        return unselectedForeground;
      }),
      side: WidgetStateProperty.all(BorderSide(color: borderColor)),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontFamily: "Plus Jakarta",
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
        ),
      ),
    ),
  );
}
