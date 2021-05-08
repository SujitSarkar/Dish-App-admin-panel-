import 'package:admin_app/pages/home_page.dart';
import 'package:admin_app/pages/lainman_home_page.dart';
import 'package:admin_app/providers/public_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/public_variables/variables.dart';
import 'package:admin_app/widgets/buttons.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:admin_app/widgets/routing_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  String _phone = '', _password = '';
  bool _admin = true;
  int _counter=0;

  _customInit(PublicProvider pProvider)async{
    setState(()=>_counter++);
    await pProvider.checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);
    if(_counter==0) _customInit(pProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: AppBar(
        //title: Text('লগ ইন'),
        elevation: 0,
        centerTitle: true,
      ),
      body: pProvider.internetConnected==true? _bodyUI(size, pProvider):NoInternet(pProvider),
    );
  }

  Widget _bodyUI(Size size, PublicProvider pProvider) => Stack(
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
                        left: 15, right: 15, top: size.width * .08),
                    child: Text(Variables.appTitle,style: TextStyle(color: Colors.white,fontSize: size.width*.09),),
                    // child: Hero(
                    //   tag: 'hero-login',
                    //   child: Image.asset(
                    //     'assets/g_banner.png',
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
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
              child: buildBody(size, pProvider),
            ),
          ),
        ],
      );

  Widget buildBody(Size size, PublicProvider pProvider) => Column(
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
                  _textField('মোবাইল নাম্বার',
                      'assets/field-icon/icon_phone.png', size),
                  _textField(
                      'পাসওয়ার্ড', "assets/field-icon/icon_password.png", size),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: ()=>setState(()=>_admin=true),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (state) => _admin?CustomColors.appThemeColor:CustomColors.whiteColor)),
                          child: Text(
                            'এডমিন',
                            style: TextStyle(color: _admin? Colors.white:CustomColors.appThemeColor),
                          )),
                      TextButton(onPressed: ()=>setState(()=>_admin=false),
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.resolveWith(
                                      (state) => !_admin?CustomColors.appThemeColor:CustomColors.whiteColor)),
                          child: Text(
                            'লাইন ম্যান',
                            style: TextStyle(color: !_admin? Colors.white:CustomColors.appThemeColor),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async{
                      await pProvider.checkConnectivity().then((value){
                        if(pProvider.internetConnected==true) _formValidation(pProvider);
                        else showInfo('কোনও ইন্টারনেট সংযোগ নেই!');
                      },onError: (error)=>showInfo(error.toString()));
                    },

                    child: shadowButton(size, 'লগ ইন'),
                  ),
                  // GestureDetector(
                  //   onTap: () => Navigator.push(context,
                  //       AnimationPageRoute(navigateTo: RecoverPassword())),
                  //   child: _admin? Padding(
                  //     padding: EdgeInsets.only(top: 25, left: 10, right: 10),
                  //     child: RichText(
                  //       textAlign: TextAlign.center,
                  //       text: TextSpan(children: [
                  //         TextSpan(
                  //             text: 'পাসওয়ার্ড পরিবর্তন করুন',
                  //             style: Design.titleStyle(size).copyWith(
                  //               decoration: TextDecoration.underline,
                  //               color: CustomColors.textColor,
                  //             )),
                  //       ]),
                  //     ),
                  //   ):Container(),
                  // ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                launchInWebViewWithJavaScript(context, 'https://glamworlditltd.com/');
              },
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

  Widget _textField(String hint, String prefixAsset, Size size) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: TextField(
            keyboardType: hint == 'মোবাইল নাম্বার'
                ? TextInputType.number
                : TextInputType.text,
            obscureText: hint == 'পাসওয়ার্ড'
                ? _isObscure
                    ? true
                    : false
                : false,
            style: Design.subTitleStyle(size).copyWith(
              color: CustomColors.textColor,
            ),
            onChanged: (val) =>
                hint == 'মোবাইল নাম্বার' ? _phone = val : _password = val,
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
              suffixIcon: hint == 'পাসওয়ার্ড'
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

  void _formValidation(PublicProvider pProvider) async{
    if (_phone.isNotEmpty && _password.isNotEmpty) {
      if (_phone.length == 11) {

        if(_admin==true){
          showLoadingDialog('অপেক্ষা করুন...');
          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Admin')
              .where('phone', isEqualTo: _phone).get();
          final List<QueryDocumentSnapshot> adminSnapshot = snapshot.docs;
          if(adminSnapshot.isNotEmpty){
            if(adminSnapshot[0].get('password')==_password){
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('phone', _phone).then((value){
                pref.setString('identifier', 'admin');
                closeLoadingDialog();
                Navigator.pushAndRemoveUntil(context, AnimationPageRoute(navigateTo: HomePage()), (route) => false);
              },onError: (error){
                closeLoadingDialog();
                showErrorMgs(error.toString());
              });

            }else{
              closeLoadingDialog();
              showErrorMgs('ভুল পাসওয়ার্ড!');
            }
          }else{
            closeLoadingDialog();
            showErrorMgs('ভুল নাম্বার!');
          }
        }
        else if(_admin==false){
          showLoadingDialog('অপেক্ষা করুন...');
          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('LainMan')
              .where('phone', isEqualTo: _phone).get();
          final List<QueryDocumentSnapshot> adminSnapshot = snapshot.docs;
          if(adminSnapshot.isNotEmpty){
            if(adminSnapshot[0].get('password')==_password){
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('phone', _phone).then((value){
                pref.setString('identifier', 'lainMan');
                closeLoadingDialog();
                Navigator.pushAndRemoveUntil(context, AnimationPageRoute(navigateTo: LainManHome()), (route) => false);
              },onError: (error){
                closeLoadingDialog();
                showErrorMgs(error.toString());
              });

            }else{
              closeLoadingDialog();
              showErrorMgs('ভুল পাসওয়ার্ড!');
            }
          }else{
            closeLoadingDialog();
            showErrorMgs('ভুল নাম্বার!');
          }
        }
      } else
        showInfo('মোবাইল নাম্বার ১১ সংখ্যার হতে হবে');
    } else
      showInfo('মোবাইল এবং পাসওয়ার্ড প্রদান করুন');
  }
}
