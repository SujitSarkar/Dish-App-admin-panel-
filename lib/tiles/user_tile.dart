import 'package:admin_app/model/user_model.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserTile  extends StatelessWidget {
  int index;
  List<UserModel> userList;
  UserTile({this.index,this.userList});

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
        leading: Icon(Icons.person,
            color: Theme.of(context).primaryColor,
            size: size.width*.12),

        title:
        ExpandableText(
          userList[index].name,
          expandText: '>>',
          collapseText: '<<',
          maxLines: 1,
          linkColor: Theme.of(context).primaryColor,
          textAlign: TextAlign.justify,
          style: Design.subTitleStyle(size).copyWith(color: CustomColors.textColor,fontWeight: FontWeight.w500),
        ),

        subtitle: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            //text: 'Hello ',
            style: Design.subTitleStyle(size),
            children: <TextSpan>[
              TextSpan(text: 'মোবাইল: ',style: TextStyle(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
              TextSpan(text: userList[index].phone,style: TextStyle(color: CustomColors.liteGrey)),

            ],
          ),
        ),
      ),
    );
  }
}
