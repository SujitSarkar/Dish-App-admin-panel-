import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoInternet extends StatelessWidget {
  var provider;
  NoInternet(this.provider);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: CustomColors.whiteColor,
      height: size.height,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.wifi_exclamationmark,
            color: CustomColors.warningColor,
            size: size.width*.4,
          ),
          Text(
            'কোনও ইন্টারনেট সংযোগ নেই !',
            textAlign: TextAlign.center,
            style: Design.titleStyle(size).copyWith(color: CustomColors.textColor),
          ),
          Text(
            'আপনার ডিভাইসটি ওয়াইফাই বা সেলুলার ডেটার সাথে সংযুক্ত করুন',
            textAlign: TextAlign.center,
            style:  Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey),
          ),
          SizedBox(height: size.width*.05),

          TextButton(
              onPressed: ()=>provider.checkConnectivity(),
              child: Text(
                'রিফ্রেশ করুন',
                style: Design.subTitleStyle(size).copyWith(color: CustomColors.appThemeColor,fontWeight: FontWeight.bold),
              )
          )
        ],
      ),
    );
  }
}
