import 'package:admin_app/providers/public_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/widgets/buttons.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoverPassword extends StatefulWidget {
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  bool _isObscure = false, _otpVerified=false;
  String _phone='',_password='',_confirmPassword='';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: AppBar(
        title: Text('পাসওয়ার্ড পরিবর্তন করুন'),
        elevation: 0,
        centerTitle: true,
      ),
      body: _bodyUI(size,pProvider),
    );
  }

  Widget _bodyUI(Size size,PublicProvider pProvider) => Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          color: CustomColors.appThemeColor,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 15,right: 15, top: size.width*.08),
                child: Hero(
                  tag: 'hero-login',
                  child: Image.asset(
                    'assets/g_banner.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
              color: CustomColors.whiteColor,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(50.0),
                topRight: const Radius.circular(50.0),
              )),
          child: buildBody(size,pProvider),
        ),
      ),
    ],
  );

  Widget buildBody(Size size,PublicProvider pProvider)=> Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      SizedBox(
        height: 0,
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 30),
              _textField('+88 সহ মোবাইল নাম্বার', 'assets/field-icon/icon_phone.png', size),
              _otpVerified==true? _textField('পাসওয়ার্ড', "assets/field-icon/icon_password.png", size):Container(),
              _otpVerified==true? _textField('কনফার্ম পাসওয়ার্ড', "assets/field-icon/icon_password.png", size):Container(),
              SizedBox(height: 12),
              _otpVerified==false?GestureDetector(
                onTap: ()=>_formValidation(pProvider,'নিশ্চিত করুন'),
                child: shadowButton(size,'নিশ্চিত করুন'),
              ):Container(),

              _otpVerified==true?GestureDetector(
                onTap: ()=>_formValidation(pProvider,'পরিবর্তন করুন'),
                child: shadowButton(size,'পরিবর্তন করুন'),
              ):Container(),

            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: (){},
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


  Widget _textField(String hint, String prefixAsset, Size size) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: TextField(
            keyboardType:
            hint == '+88 সহ মোবাইল নাম্বার'
                ? TextInputType.number
                : TextInputType.text,
            readOnly: hint=='+88 সহ মোবাইল নাম্বার' && _otpVerified==true
                ?true:false,
            obscureText:hint == 'পাসওয়ার্ড'? _isObscure ? true : false:false,
            style: Design.subTitleStyle(size).copyWith(
              color: CustomColors.textColor,
            ),
            onChanged: (val) =>
            hint == '+88 সহ মোবাইল নাম্বার' ? _phone = val
                :hint == 'পাসওয়ার্ড'? _password=val
                : _confirmPassword=val,
            decoration: Design.loginFormDecoration.copyWith(
              hintText: hint,
              labelText: hint,
              prefixIcon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  prefixAsset,
                  width: 15,
                  height: 15,
                ),
              ),
              suffixIcon: hint == 'পাসওয়ার্ড' || hint =='কনফার্ম পাসওয়ার্ড'
                  ? GestureDetector(
                  onTap: () => setState(() => _isObscure = !_isObscure),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      _isObscure
                          ? "assets/field-icon/icon_eye_close.png"
                          : "assets/field-icon/icon_eye_open.png",
                      width: 15,
                      height: 15,
                    ),
                  ))
                  : null,
            )),
      );

  void _formValidation(PublicProvider pProvider, String identifier){

    if(identifier=='নিশ্চিত করুন'){
      if(_phone.isNotEmpty){
        if(_phone.length==14){
          if(_phone.contains('+88')){
            showLoadingDialog('অপেক্ষা করুন...');
            Future.delayed(Duration(seconds: 2)).then((value){
              closeLoadingDialog();
              setState(()=> _otpVerified=true);
            });
          } else showInfo('+88 নিশ্চিত করা হয়নি');
        }else showInfo('+88 সহ ১১ সংখার মোবাইল নাম্বার নিশ্চিত করুন');
      }else showInfo('মোবাইল নাম্বার নিশ্চিত করুন');
    }else{
      if(_password.isNotEmpty && _confirmPassword.isNotEmpty){
        if(_password==_confirmPassword){

        }else showInfo('পাসওয়ার্ড দুটির মধ্যে কোন মিল নেই');
      }else showInfo('পাসওয়ার্ড নিশ্চিত করুন');
    }
  }
}
