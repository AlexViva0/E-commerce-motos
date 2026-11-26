import 'package:flutter/material.dart';

import '../constants.dart';

ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(defaultPadding),
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    disabledBackgroundColor: blackColor20,
    disabledForegroundColor: blackColor60,
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

FilledButtonThemeData filledButtonThemeData = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    padding: const EdgeInsets.all(defaultPadding),
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    disabledBackgroundColor: blackColor20,
    disabledForegroundColor: blackColor60,
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
