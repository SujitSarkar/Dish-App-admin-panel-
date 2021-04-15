import 'package:flutter/material.dart';

class CustomColors {
  static final Map<int, Color> themeMapColor = {
    //RGB Color Code (0, 194, 162) Hex: 0xff0095B2
    50: Color.fromRGBO(0, 149, 178, .1),
    100: Color.fromRGBO(0, 149, 178, .2),
    200: Color.fromRGBO(0, 149, 178, .3),
    300: Color.fromRGBO(0, 149, 178, .4),
    400: Color.fromRGBO(0, 149, 178, .5),
    500: Color.fromRGBO(0, 149, 178, .6),
    600: Color.fromRGBO(0, 149, 178, .7),
    700: Color.fromRGBO(0, 149, 178, .8),
    800: Color.fromRGBO(0, 149, 178, .9),
    900: Color.fromRGBO(0, 149, 178, 1),
  };

  static final Color appThemeColor = Color(0xff0095B2);

  static final Color whiteColor = Colors.white;
  static final Color blackColor = Colors.black;
  //static final Color textColor = Colors.grey[900];
  static final Color textColor = Color(0xFF0F2E48);
  static final Color deepGrey = Colors.grey[800];
  static final Color liteGrey = Colors.grey[700];
  static final Color liteGrey2 = Colors.grey[600];
  static final Color warningColor = Color(0xffFF7000);
  static final Color borderColor = Color(0xFFAAB5C3);
  static final Color greyWhite =Color(0xFFF3F3F5);

  static final LinearGradient gradientColor =
      LinearGradient(colors: [appThemeColor, Color(0xff17B1AD)]);
  static final LinearGradient whiteGradientColor =
      LinearGradient(colors: [Color(0xffD6EDEF), Color(0xffDAE3EA)]);
}
