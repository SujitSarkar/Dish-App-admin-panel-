import 'package:admin_app/public_variables/colors.dart';
import 'package:flutter/material.dart';

class Design {

  static final BorderRadius borderRadius =
      BorderRadius.all(Radius.circular(10));
  static final BorderRadius buttonRadius =
      BorderRadius.all(Radius.circular(50));

  static final BoxShadow cardShadow =
      BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(0, 1));

  static TextStyle titleStyle(Size size) => TextStyle(
      fontSize: size.width * .05,
      fontWeight: FontWeight.w500,
      color: CustomColors.whiteColor);

  static TextStyle subTitleStyle(Size size) => TextStyle(
      fontSize: size.width * .04,
      fontWeight: FontWeight.w400,
      color: CustomColors.whiteColor);

  static TextStyle warningSubTitleStyle(Size size) => TextStyle(
      fontSize: size.width * .04,
      fontWeight: FontWeight.w400,
      color: CustomColors.warningColor);

  static InputDecoration formDecoration(Size size)=> InputDecoration(
    labelText: '',
    alignLabelWithHint: true,
    filled: null,
    fillColor: null,
    border: null,
    labelStyle: TextStyle(
      fontSize: size.width*.04,
    )
  );

  static final BoxDecoration modalDecoration = BoxDecoration(
    borderRadius: borderRadius,
    color: CustomColors.whiteColor
  );

  static InputDecoration loginFormDecoration = InputDecoration(

      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: CustomColors.borderColor)),
      filled: true,
      fillColor: CustomColors.whiteColor,
      focusColor: CustomColors.borderColor,
      alignLabelWithHint: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: CustomColors.borderColor)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: CustomColors.borderColor)),
      hintText: '');
}

