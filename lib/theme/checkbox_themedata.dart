import 'package:flutter/material.dart';

import '../constants.dart';

CheckboxThemeData checkboxThemeData = CheckboxThemeData(
  checkColor: MaterialStateProperty.all(Colors.white),
  fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
    if (states.contains(MaterialState.selected)) {
      return primaryColor;
    }
    return Colors.transparent;
  }),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(defaultBorderRadious / 2),
    ),
  ),
  side: const BorderSide(color: whileColor40, width: 1.5),
);
