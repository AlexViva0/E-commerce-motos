import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

// Just for demo
const productDemoImg1 = "https://i.imgur.com/CGCyp1d.png";
const productDemoImg2 = "https://i.imgur.com/AkzWQuJ.png";
const productDemoImg3 = "https://i.imgur.com/J7mGZ12.png";
const productDemoImg4 = "https://i.imgur.com/q9oF9Yq.png";
const productDemoImg5 = "https://i.imgur.com/MsppAcx.png";
const productDemoImg6 = "https://i.imgur.com/JfyZlnO.png";

// End For demo

const grandisExtendedFont = "Grandis Extended";

// On color 80, 60.... those means opacity

const Color primaryColor = Color(0xFFE63E1C);
const Color primaryDarkColor = Color(0xFFB82E12);
const Color accentColor = Color(0xFFFFB020);
const Color surfaceColor = Color(0xFFF5F6F8);

const MaterialColor primaryMaterialColor =
    MaterialColor(0xFFE63E1C, <int, Color>{
  50: Color(0xFFFDECE8),
  100: Color(0xFFFAD0C7),
  200: Color(0xFFF6B0A1),
  300: Color(0xFFF18F7A),
  400: Color(0xFFEC674B),
  500: Color(0xFFE63E1C),
  600: Color(0xFFD13617),
  700: Color(0xFFB82E12),
  800: Color(0xFF9E260E),
  900: Color(0xFF7A1B08),
});

const Color blackColor = Color(0xFF15171C);
const Color blackColor80 = Color(0xFF444549);
const Color blackColor60 = Color(0xFF737477);
const Color blackColor40 = Color(0xFFA1A2A4);
const Color blackColor20 = Color(0xFFD0D1D2);
const Color blackColor10 = Color(0xFFE8E8E8);
const Color blackColor5 = Color(0xFFF3F3F4);

const Color whiteColor = Colors.white;
const Color whileColor80 = Color(0xFFCCCCCC);
const Color whileColor60 = Color(0xFF999999);
const Color whileColor40 = Color(0xFF666666);
const Color whileColor20 = Color(0xFF333333);
const Color whileColor10 = Color(0xFF191919);
const Color whileColor5 = Color(0xFF0D0D0D);

const Color greyColor = Color(0xFFA1A5B0);
const Color lightGreyColor = Color(0xFFF5F6F8);
const Color darkGreyColor = Color(0xFF1A1C21);
// const Color greyColor80 = Color(0xFFC6C4CF);
// const Color greyColor60 = Color(0xFFD4D3DB);
// const Color greyColor40 = Color(0xFFE3E1E7);
// const Color greyColor20 = Color(0xFFF1F0F3);
// const Color greyColor10 = Color(0xFFF8F8F9);
// const Color greyColor5 = Color(0xFFFBFBFC);

const Color purpleColor = primaryColor;
const Color successColor = Color(0xFF2ED573);
const Color warningColor = Color(0xFFFFB020);
const Color errorColor = Color(0xFFEA5B5B);

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'passwords must have at least one special character')
]);

final emaildValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: "Enter a valid email address"),
]);

const pasNotMatchErrorText = "passwords do not match";
