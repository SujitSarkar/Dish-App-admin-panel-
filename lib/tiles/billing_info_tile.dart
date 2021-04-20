import 'package:admin_app/model/billing_info_model.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class BillingInfoTile extends StatelessWidget {
  int index;
  List<BillingInfoModel> allBillList;

  BillingInfoTile({this.index,this.allBillList});

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
        title: Text('${allBillList[index].name}',maxLines: 1,
            textAlign: TextAlign.left,
            style: Design.subTitleStyle(size).copyWith(color: CustomColors.textColor,fontWeight: FontWeight.bold)),
        subtitle: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            //text: 'Hello ',
            style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey),
            children: <TextSpan>[
              TextSpan(text: '${allBillList[index].userPhone}\n'),
              TextSpan(text: 'বিলিং নাম্বার: ',style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '${allBillList[index].billingNumber}\n'),
              TextSpan(text: 'মাস এবং পরিমান: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '${allBillList[index].monthYear}, ${allBillList[index].amount} ৳\n'),
              TextSpan(text: 'ট্রাঃ আইডি: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '${allBillList[index].transactionId}'),
            ],
          ),
        ),
      ),
    );
  }
}