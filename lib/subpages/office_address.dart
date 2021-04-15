import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OfficeAddress extends StatefulWidget {

  @override
  _OfficeAddressState createState() => _OfficeAddressState();
}

class _OfficeAddressState extends State<OfficeAddress> {
  TextEditingController _addressController=TextEditingController();
  TextEditingController _supportNumberController=TextEditingController();

  @override
  void initState() {
    super.initState();
    _addressController.text = 'হাউস-১৬, সোনারগাঁও জনপথ রোড, উত্তরা, ঢাকা';
    _supportNumberController.text = '01830200087,\n019295558764';
  }

  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context,'অফিসের ঠিকানা'),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size)=> Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      SizedBox(height: 10),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 30),
              _textField('অফিসের ঠিকানা',size),
              _textField('গ্রাহক সেবা নাম্বার',size),

              SizedBox(height: 12),

              GestureDetector(
                onTap: (){},
                child: shadowButton(size, 'পরিবর্তন করুন'),
              ),

            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {},
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: 'Powered by ',
                  style: Design.subTitleStyle(size).copyWith(
                    color: CustomColors.liteGrey2,
                  )),
              TextSpan(
                  text: 'Glamworld IT',
                  style: Design.subTitleStyle(size).copyWith(
                    decoration: TextDecoration.underline,
                    color: CustomColors.textColor,
                  )),
            ]),
          ),
        ),
      ),
    ],
  );

  Widget _textField(String hint, Size size) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: TextField(
          controller: hint == 'অফিসের ঠিকানা'? _addressController:_supportNumberController,
          textCapitalization: hint == 'অফিসের ঠিকানা'
              ? TextCapitalization.words:TextCapitalization.none,
            keyboardType:
            hint == 'অফিসের ঠিকানা'
                ? TextInputType.text
                : TextInputType.phone,
            maxLines: 3,
            textAlign:  hint == 'অফিসের ঠিকানা'
                ? TextAlign.justify:TextAlign.start,
            style: Design.subTitleStyle(size).copyWith(
              color: CustomColors.textColor,
            ),
            onChanged: (val) => hint == 'অফিসের ঠিকানা'
                ? _addressController.text = val
                : _supportNumberController.text = val,
            decoration: Design.loginFormDecoration.copyWith(
              hintText: hint,
              labelText: hint
            )),
      );
}
