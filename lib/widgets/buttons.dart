import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:flutter/material.dart';


Widget smallGradientButton(BuildContext context, String buttonName){
  final Size size = MediaQuery.of(context).size;
  return Container(
    //height: size.width*.11,
    width: size.width*.5,
    margin: EdgeInsets.all(2),
    padding: EdgeInsets.symmetric(horizontal:size.width*.015,vertical: size.width*.027),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50)),
        gradient: CustomColors.gradientColor,
      boxShadow: [Design.cardShadow]
    ),
    child: Text(buttonName,textAlign: TextAlign.center,style: TextStyle(
        fontSize: size.width*.045,
        fontWeight: FontWeight.w500,
        color: CustomColors.whiteColor
    ),),
  );
}

Widget shadowButton(Size size,String buttonName){
  return SizedBox(
      height: size.height * 0.07,
      width: size.width * 0.7,
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: CustomColors.appThemeColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10),
            child: Center(
                child: Text(
                  buttonName,
                  style: Design.titleStyle(size),
                )),
          )));
}