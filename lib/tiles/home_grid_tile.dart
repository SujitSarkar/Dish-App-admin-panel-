import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/public_variables/variables.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class HomeMenuTile extends StatelessWidget {
  int index;
  HomeMenuTile({this.index});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width*.02,vertical: size.width*.02),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: Design.borderRadius,
          //gradient: CustomColors.gradientColor,
        boxShadow: [Design.cardShadow]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Variables.homeMenuIcon[index], size: size.width*.10, color: CustomColors.whiteColor),
          Text(
            Variables.homeMenuText[index],
            maxLines: 3,
            style: Design.subTitleStyle(size),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}