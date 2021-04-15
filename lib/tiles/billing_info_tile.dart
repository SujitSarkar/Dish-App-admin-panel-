import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class BillingInfoTile extends StatelessWidget {
  int index;
  BillingInfoTile({this.index});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      //height: size.width*.25,
      margin: EdgeInsets.only(left: 10,right: 10,top: 15),
      decoration: BoxDecoration(borderRadius: Design.borderRadius,
          gradient: CustomColors.whiteGradientColor,
          boxShadow: [Design.cardShadow]
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 5,right: 8,top: 0,bottom: 0),
        leading: Image.asset('assets/icon/taka1.png',height: size.width*.15,width: size.width*.15),
        title: Text('Mr. Ismail Hossain',maxLines: 1,
            style: Design.subTitleStyle(size).copyWith(color: CustomColors.textColor,fontWeight: FontWeight.bold)),
        subtitle: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            //text: 'Hello ',
            style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey),
            children: <TextSpan>[
              TextSpan(text: 'Phone: ',style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '01830200087\n'),
              TextSpan(text: 'Amount: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '300 Tk\n'),
              TextSpan(text: 'T.ID: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: 'AJH6253653HJH65656'),
            ],
          ),
        ),
      ),
    );
  }
}