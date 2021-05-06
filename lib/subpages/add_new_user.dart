import 'package:admin_app/providers/user_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/buttons.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewUser extends StatefulWidget {
  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  bool _isObscure = false;
  int _count=0;

  void _customInit(UserProvider uProvider)async{
    setState(()=>_count++);
    uProvider.userModel.name='';
    uProvider.userModel.phone='';
    uProvider.userModel.password='';
    uProvider.userModel.nID='';
    uProvider.userModel.fatherName='';
    uProvider.userModel.address='';
    await uProvider.checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    final UserProvider uProvider = Provider.of<UserProvider>(context);
    if(_count==0) _customInit(uProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context,'নতুন গ্রাহক নিবন্ধন করুন'),
      ),
      body: uProvider.internetConnected==true? _bodyUI(size,uProvider): NoInternet(uProvider),
    );
  }
  Widget _bodyUI(Size size,UserProvider uProvider)=> Column(
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
              _textField(
                  'নাম', "assets/field-icon/icon_user.png", size,uProvider),
              _textField('মোবাইল নাম্বার',
                  'assets/field-icon/icon_phone.png', size,uProvider),
              _textField('পাসওয়ার্ড',
                  "assets/field-icon/icon_password.png", size,uProvider),
              _textField('লাইন নাম্বার',
                  "assets/field-icon/icon_id.png", size,uProvider),
              _textField(
                  'বাবার নাম', "assets/field-icon/icon_user.png", size,uProvider),
              _textField('বাড়ির ঠিকানা',
                  "assets/field-icon/icon_address.png", size,uProvider),
              SizedBox(height: 12),

              GestureDetector(
                onTap: ()async{
                  uProvider.checkConnectivity().then((value){
                    if(uProvider.internetConnected==true){
                      _formValidation(uProvider);
                    }else{
                    showInfo('কোনও ইন্টারনেট সংযোগ নেই!');
                    }
                  },onError: (error)=>showInfo(error.toString()));
                  },
                child: shadowButton(size, 'নিবন্ধন করুন'),
              ),

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

  Widget _textField(String hint, String prefixAsset, Size size,UserProvider uProvider) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: TextField(
            keyboardType:
            hint == 'মোবাইল নাম্বার' || hint == 'লাইন নাম্বার'
                ? TextInputType.phone
                : TextInputType.text,
            obscureText:hint == 'পাসওয়ার্ড'? _isObscure ? true : false:false,
            style: Design.subTitleStyle(size).copyWith(
              color: CustomColors.textColor,
            ),
            onChanged: (val) => hint == 'নাম'
                ? uProvider.userModel.name = val
                :hint == 'মোবাইল নাম্বার'
                ? uProvider.userModel.phone = val
                : hint == 'পাসওয়ার্ড'
                ? uProvider.userModel.password = val
                : hint == 'লাইন নাম্বার'
                ? uProvider.userModel.nID = val
                : hint == 'বাবার নাম'
                ? uProvider.userModel.fatherName = val
                : uProvider.userModel.address = val,
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

  void _formValidation(UserProvider uProvider)async{
    if(uProvider.userModel.name.isNotEmpty &&
        uProvider.userModel.phone.isNotEmpty &&
        uProvider.userModel.password.isNotEmpty &&
        uProvider.userModel.nID.isNotEmpty &&
        uProvider.userModel.fatherName.isNotEmpty &&
        uProvider.userModel.address.isNotEmpty){
      if(uProvider.userModel.phone.length==11){
        showLoadingDialog('অপেক্ষা করুন...');
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users')
            .where('phone', isEqualTo: uProvider.userModel.phone).get();
        final List<QueryDocumentSnapshot> userSnapshot = snapshot.docs;
        if(userSnapshot.isEmpty){
          uProvider.addNewUser(uProvider).then((value){
            if(value==true){
              closeLoadingDialog();
              showSuccessMgs('নতুন গ্রাহক নিবন্ধন সফল হয়েছে');
              Navigator.pop(context);
            }else{
              closeLoadingDialog();
              showErrorMgs('নতুন গ্রাহক নিবন্ধন সফল হয়েছে!\nআবার চেষ্টা করুন');
            }
          },onError: (error){
            closeLoadingDialog();
            showErrorMgs(error.toString());
          });
        } else {
          closeLoadingDialog();
          showInfo('এই নাম্বার দিয়ে আগে থেকেই গ্রাহক নিবন্ধন করা আছে!');
        }
      }else showInfo('মোবাইল নাম্বার ১১ সংখ্যার হতে হবে');
    }else showInfo('ফর্ম পুরন করুন');
  }
}

