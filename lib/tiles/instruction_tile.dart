import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class InstructionTile extends StatelessWidget {
  String content;
  InstructionTile(this.content);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
          borderRadius: Design.borderRadius,
          gradient: CustomColors.gradientColor,
          boxShadow: [Design.cardShadow]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(content,
            textAlign: TextAlign.justify,
            style: Design.subTitleStyle(size)),
      ),
    );
  }
}
