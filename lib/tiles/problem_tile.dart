import 'package:admin_app/model/problem_model.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// ignore: must_be_immutable
class ProblemTile extends StatelessWidget {
  int index;
  List<ProblemModel> problemList;
  ProblemTile({this.index,this.problemList});

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
        leading: Icon(Icons.error_outline_outlined,
          color: Theme.of(context).primaryColor,
          size: size.width*.12),

        title:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                //text: 'Hello ',
                style: Design.subTitleStyle(size).copyWith(color: CustomColors.textColor),
                children: <TextSpan>[
                  //TextSpan(text: 'নাম: ',style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${problemList[index].name}\n'),

                  //TextSpan(text: 'মোবাইল: ',style: TextStyle(fontWeight: FontWeight.bold,color: CustomColors.textColor)),
                  TextSpan(text: '${problemList[index].phone}',style: TextStyle(color: CustomColors.liteGrey)),

                ],
              ),
            ),
            ExpandableText(
              '${problemList[index].problem}',
              expandText: '>>',
              collapseText: '<<',
              maxLines: 1,
              linkColor: Theme.of(context).primaryColor,
              textAlign: TextAlign.justify,
              style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey,fontWeight: FontWeight.w500),
            ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(problemList[index].timeStamp))).toString(),
              style: Design.subTitleStyle(size).copyWith(color: Colors.grey[700])),
            Text(
              problemList[index].state=='no'?'অমীমাংসিত':'মীমাংসিত',
              style: Design.subTitleStyle(size).copyWith(color: Colors.grey[700],fontStyle: FontStyle.italic),
            )
          ],
        ),
          ],
        ),
      ),
    );
  }
}