import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

const Color darkBackgroundColor = Color(0xFF0E0F12);
const Color darkSurfaceColor = Color(0xFF1A1C21);
const Color darkBorderColor = Color(0xFF2B2E36);
const Color darkTextPrimary = Color(0xFFF5F6F8);
const Color darkTextSecondary = Color(0xFFB3B7C3);
const Color darkTextMuted = Color(0xFF8C919E);

const AppBarTheme appBarLightTheme = AppBarTheme(
  backgroundColor: Colors.white,
  foregroundColor: blackColor,
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: 0,
  centerTitle: false,
  systemOverlayStyle: SystemUiOverlayStyle.dark,
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
  backgroundColor: darkBackgroundColor,
  foregroundColor: darkTextPrimary,
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: 0,
  centerTitle: false,
  systemOverlayStyle: SystemUiOverlayStyle.light,
  iconTheme: IconThemeData(color: darkTextPrimary),
  actionsIconTheme: IconThemeData(color: darkTextPrimary),
  titleTextStyle: TextStyle(
    fontFamily: grandisExtendedFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: darkTextPrimary,
  ),
);

const BottomNavigationBarThemeData bottomNavigationBarLightTheme =
    BottomNavigationBarThemeData(
  backgroundColor: Colors.white,
  elevation: 0,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: primaryColor,
  unselectedItemColor: blackColor40,
  selectedLabelStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
  unselectedLabelStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
);

const BottomNavigationBarThemeData bottomNavigationBarDarkTheme =
    BottomNavigationBarThemeData(
  backgroundColor: darkSurfaceColor,
  elevation: 0,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: primaryColor,
  unselectedItemColor: darkTextMuted,
  selectedLabelStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
  unselectedLabelStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
);

const CardThemeData cardLightThemeData = CardThemeData(
  color: Colors.white,
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  margin: EdgeInsets.symmetric(vertical: 4),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
    side: BorderSide(color: blackColor10),
  ),
);

const CardThemeData cardDarkThemeData = CardThemeData(
  color: darkSurfaceColor,
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  margin: EdgeInsets.symmetric(vertical: 4),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
    side: BorderSide(color: darkBorderColor),
  ),
);

const ListTileThemeData listTileLightThemeData = ListTileThemeData(
  iconColor: blackColor80,
  textColor: blackColor,
  subtitleTextStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 13,
    color: blackColor60,
  ),
);

const ListTileThemeData listTileDarkThemeData = ListTileThemeData(
  iconColor: darkTextSecondary,
  textColor: darkTextPrimary,
  subtitleTextStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 13,
    color: darkTextSecondary,
  ),
);

const BottomSheetThemeData bottomSheetLightThemeData = BottomSheetThemeData(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.transparent,
  dragHandleColor: blackColor20,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
);

const BottomSheetThemeData bottomSheetDarkThemeData = BottomSheetThemeData(
  backgroundColor: darkSurfaceColor,
  surfaceTintColor: Colors.transparent,
  dragHandleColor: Color(0xFF474B57),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
);

final SwitchThemeData switchLightThemeData = SwitchThemeData(
  thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.selected)) return Colors.white;
    return blackColor60;
  }),
  trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.selected)) return primaryColor;
    return blackColor10;
  }),
  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.selected)) return Colors.transparent;
    return blackColor20;
  }),
);

final SwitchThemeData switchDarkThemeData = SwitchThemeData(
  thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.selected)) return Colors.white;
    return darkTextSecondary;
  }),
  trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.selected)) return primaryColor;
    return const Color(0xFF282B34);
  }),
  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.selected)) return Colors.transparent;
    return darkBorderColor;
  }),
);

final RadioThemeData radioLightThemeData = RadioThemeData(
  fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.selected)) return primaryColor;
    return blackColor40;
  }),
);

final RadioThemeData radioDarkThemeData = RadioThemeData(
  fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.selected)) return primaryColor;
    return darkTextMuted;
  }),
);

const SnackBarThemeData snackBarLightThemeData = SnackBarThemeData(
  backgroundColor: blackColor,
  contentTextStyle: TextStyle(
    fontFamily: "Rubik",
    color: Colors.white,
    fontSize: 13.5,
  ),
);

const SnackBarThemeData snackBarDarkThemeData = SnackBarThemeData(
  backgroundColor: Color(0xFF252830),
  contentTextStyle: TextStyle(
    fontFamily: "Rubik",
    color: darkTextPrimary,
    fontSize: 13.5,
  ),
);

ScrollbarThemeData scrollbarThemeData = ScrollbarThemeData(
  thumbColor: WidgetStateProperty.all(const Color(0x80E63E1C)),
  trackColor: WidgetStateProperty.all(blackColor10),
  radius: const Radius.circular(8),
);

ScrollbarThemeData scrollbarDarkThemeData = ScrollbarThemeData(
  thumbColor: WidgetStateProperty.all(const Color(0x99E63E1C)),
  trackColor: WidgetStateProperty.all(darkBorderColor),
  radius: const Radius.circular(8),
);

ChipThemeData chipLightThemeData = const ChipThemeData(
  backgroundColor: lightGreyColor,
  selectedColor: primaryColor,
  secondarySelectedColor: primaryColor,
  disabledColor: blackColor10,
  surfaceTintColor: Colors.transparent,
  checkmarkColor: Colors.white,
  deleteIconColor: blackColor60,
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  labelStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: blackColor,
  ),
  secondaryLabelStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
    side: BorderSide(color: blackColor10),
  ),
  side: BorderSide(color: blackColor10),
);

ChipThemeData chipDarkThemeData = const ChipThemeData(
  backgroundColor: darkSurfaceColor,
  selectedColor: primaryColor,
  secondarySelectedColor: primaryColor,
  disabledColor: darkBorderColor,
  surfaceTintColor: Colors.transparent,
  checkmarkColor: Colors.white,
  deleteIconColor: darkTextSecondary,
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  labelStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: darkTextPrimary,
  ),
  secondaryLabelStyle: TextStyle(
    fontFamily: "Rubik",
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
    side: BorderSide(color: darkBorderColor),
  ),
  side: BorderSide(color: darkBorderColor),
);

DataTableThemeData dataTableLightThemeData = DataTableThemeData(
  columnSpacing: 24,
  headingRowColor: WidgetStateProperty.all(lightGreyColor),
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
  headingRowColor: WidgetStateProperty.all(darkSurfaceColor),
  decoration: BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
    border: Border.all(color: darkBorderColor),
  ),
  dataTextStyle: const TextStyle(
    fontWeight: FontWeight.w500,
    color: darkTextPrimary,
    fontSize: 12,
  ),
);
