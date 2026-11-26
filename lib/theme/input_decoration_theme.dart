import 'package:flutter/material.dart';

import '../constants.dart';

const InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
  fillColor: lightGreyColor,
  filled: true,
  contentPadding: EdgeInsets.symmetric(
    horizontal: defaultPadding,
    vertical: 14,
  ),
  hintStyle: TextStyle(color: blackColor40, fontSize: 14),
  labelStyle: TextStyle(color: blackColor60, fontWeight: FontWeight.w500),
  floatingLabelStyle: TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w600,
  ),
  prefixIconColor: blackColor60,
  suffixIconColor: blackColor60,
  border: outlineInputBorder,
  enabledBorder: outlineInputBorder,
  focusedBorder: focusedOutlineInputBorder,
  errorBorder: errorOutlineInputBorder,
  focusedErrorBorder: errorOutlineInputBorder,
);

const InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
  fillColor: darkGreyColor,
  filled: true,
  contentPadding: EdgeInsets.symmetric(
    horizontal: defaultPadding,
    vertical: 14,
  ),
  hintStyle: TextStyle(color: whileColor40, fontSize: 14),
  labelStyle: TextStyle(color: whileColor60, fontWeight: FontWeight.w500),
  floatingLabelStyle: TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w600,
  ),
  prefixIconColor: whileColor60,
  suffixIconColor: whileColor60,
  border: outlineInputBorder,
  enabledBorder: outlineInputBorder,
  focusedBorder: focusedOutlineInputBorder,
  errorBorder: errorOutlineInputBorder,
  focusedErrorBorder: errorOutlineInputBorder,
);

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
  borderSide: BorderSide(
    color: Colors.transparent,
  ),
);

const OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
  borderSide: BorderSide(color: primaryColor, width: 1.5),
);

const OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
  borderSide: BorderSide(
    color: errorColor,
    width: 1.5,
  ),
);

OutlineInputBorder secodaryOutlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
    borderSide: BorderSide(
      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.15),
    ),
  );
}
