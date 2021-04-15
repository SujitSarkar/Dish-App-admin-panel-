import 'package:admin_app/public_variables/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PublicAppBar extends StatelessWidget {
  BuildContext context;
  String title;
  PublicAppBar(this.context,this.title);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.appThemeColor,
      title: Text(title,style: TextStyle(color: CustomColors.whiteColor)),
      elevation: 0,
    );
  }
}
