import 'package:flutter/material.dart';

import '../constants.dart';

const AppBarTheme appBarLightTheme = AppBarTheme(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: 0,
  centerTitle: false,
  iconTheme: IconThemeData(color: blackColor),
  actionsIconTheme: IconThemeData(color: blackColor),
  titleTextStyle: TextStyle(
    fontFamily: grandisExtendedFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: blackColor,
  ),
);

const AppBarTheme appBarDarkTheme = AppBarTheme(
  backgroundColor: Color(0xFF0E0F12),
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: 0,
  centerTitle: false,
  iconTheme: IconThemeData(color: Colors.white),
  actionsIconTheme: IconThemeData(color: Colors.white),
  titleTextStyle: TextStyle(
    fontFamily: grandisExtendedFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
);

ScrollbarThemeData scrollbarThemeData = ScrollbarThemeData(
  thumbColor: MaterialStateProperty.all(const Color(0x80E63E1C)),
  trackColor: MaterialStateProperty.all(blackColor10),
  radius: const Radius.circular(8),
);

ChipThemeData chipLightThemeData = ChipThemeData(
  backgroundColor: lightGreyColor,
  selectedColor: primaryColor,
  secondarySelectedColor: primaryColor,
  disabledColor: blackColor10,
  checkmarkColor: Colors.white,
  deleteIconColor: blackColor60,
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  labelStyle: const TextStyle(
    fontFamily: "Plus Jakarta",
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: blackColor,
  ),
  secondaryLabelStyle: const TextStyle(
    fontFamily: "Plus Jakarta",
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
    side: BorderSide(color: blackColor10),
  ),
  side: const BorderSide(color: blackColor10),
);

ChipThemeData chipDarkThemeData = ChipThemeData(
  backgroundColor: darkGreyColor,
  selectedColor: primaryColor,
  secondarySelectedColor: primaryColor,
  disabledColor: whileColor20,
  checkmarkColor: Colors.white,
  deleteIconColor: whileColor60,
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  labelStyle: const TextStyle(
    fontFamily: "Plus Jakarta",
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  secondaryLabelStyle: const TextStyle(
    fontFamily: "Plus Jakarta",
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
    side: BorderSide(color: whileColor20),
  ),
  side: const BorderSide(color: whileColor20),
);

DataTableThemeData dataTableLightThemeData = DataTableThemeData(
  columnSpacing: 24,
  headingRowColor: MaterialStateProperty.all(lightGreyColor),
  decoration: BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
    border: Border.all(color: blackColor10),
  ),
  dataTextStyle: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: blackColor,
  ),
);

DataTableThemeData dataTableDarkThemeData = DataTableThemeData(
  columnSpacing: 24,
  headingRowColor: MaterialStateProperty.all(darkGreyColor),
  decoration: BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
    border: Border.all(color: Colors.white10),
  ),
  dataTextStyle: const TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontSize: 12,
  ),
);
