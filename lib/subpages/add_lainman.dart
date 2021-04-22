import 'package:admin_app/providers/lain_man_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/buttons.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLainMan extends StatefulWidget {
  @override
  _AddLainManState createState() => _AddLainManState();
}

class _AddLainManState extends State<AddLainMan> {
  bool _isObscure = false;
  int _count=0;

  void _customInit(LainManProvider lmProvider)async{
    setState(()=>_count++);
    lmProvider.lainManModel.name='';
    lmProvider.lainManModel.phone='';
    lmProvider.lainManModel.password='';
    lmProvider.lainManModel.nID='';
    lmProvider.lainManModel.fatherName='';
    lmProvider.lainManModel.address='';
    await lmProvider.checkConnectivity();

  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final LainManProvider lmProvider = Provider.of<LainManProvider>(context);
    if(_count==0) _customInit(lmProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context,'নতুন লাইনম্যান নিবন্ধন করুন'),
      ),
      body: lmProvider.internetConnected==true? _bodyUI(size, lmProvider):NoInternet(lmProvider),
    );
  }

  Widget _bodyUI(Size size, LainManProvider lmProvider)=>Column(
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
                  'নাম', "assets/field-icon/icon_user.png", size,lmProvider),
              _textField('মোবাইল নাম্বার',
                  'assets/field-icon/icon_phone.png', size,lmProvider),
              SizedBox(height: 10),
              _textField('পাসওয়ার্ড',
                  "assets/field-icon/icon_password.png", size,lmProvider),
              SizedBox(height: 10),
              _textField('এন আইডি নাম্বার',
                  "assets/field-icon/icon_id.png", size,lmProvider),
              SizedBox(height: 10),
              _textField(
                  'বাবার নাম', "assets/field-icon/icon_user.png", size,lmProvider),
              SizedBox(height: 10),
              _textField('বাড়ির ঠিকানা',
                  "assets/field-icon/icon_address.png", size,lmProvider),
              SizedBox(height: 20),
              GestureDetector(
                onTap: ()async{
                  lmProvider.checkConnectivity().then((value){
                    if(lmProvider.internetConnected==true){
                      _formValidation(lmProvider);
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

  Widget _textField(String hint, String prefixAsset, Size size,LainManProvider lmProvider) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: TextField(
            keyboardType:
            hint == 'মোবাইল নাম্বার' || hint == 'এন আইডি নাম্বার'
                ? TextInputType.phone
                : TextInputType.text,
            obscureText:hint == 'পাসওয়ার্ড'? _isObscure ? true : false:false,
            style: Design.subTitleStyle(size).copyWith(
              color: CustomColors.textColor,
            ),
            onChanged: (val) => hint == 'নাম'
                ? lmProvider.lainManModel.name = val
                :hint == 'মোবাইল নাম্বার'
                ? lmProvider.lainManModel.phone = val
                : hint == 'পাসওয়ার্ড'
                ? lmProvider.lainManModel.password = val
                : hint == 'এন আইডি নাম্বার'
                ? lmProvider.lainManModel.nID = val
                : hint == 'বাবার নাম'
                ? lmProvider.lainManModel.fatherName = val
                : lmProvider.lainManModel.address = val,
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

  void _formValidation(LainManProvider lmProvider)async{
    if(lmProvider.lainManModel.name.isNotEmpty &&
        lmProvider.lainManModel.phone.isNotEmpty &&
        lmProvider.lainManModel.password.isNotEmpty &&
        lmProvider.lainManModel.nID.isNotEmpty &&
        lmProvider.lainManModel.fatherName.isNotEmpty &&
        lmProvider.lainManModel.address.isNotEmpty){
      if(lmProvider.lainManModel.phone.length==11){
        showLoadingDialog('অপেক্ষা করুন...');
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('LainMan')
            .where('phone', isEqualTo: lmProvider.lainManModel.phone).get();
        final List<QueryDocumentSnapshot> userSnapshot = snapshot.docs;
        if(userSnapshot.isEmpty){
          lmProvider.addNewLainMan(lmProvider).then((value)async{
            if(value==true){
              closeLoadingDialog();
              showSuccessMgs('নতুন লাইনম্যান নিবন্ধন সফল হয়েছে');
              await lmProvider.getAllLainMan();
              Navigator.pop(context);
            }else{
              closeLoadingDialog();
              showErrorMgs('নতুন লাইনম্যান নিবন্ধন সফল হয়েছে!\nআবার চেষ্টা করুন');
            }
          },onError: (error){
            closeLoadingDialog();
            showErrorMgs(error.toString());
          });
        } else {
          closeLoadingDialog();
          showInfo('এই নাম্বার দিয়ে আগে থেকেই লাইনম্যান নিবন্ধন করা আছে!');
        }
      }else showInfo('মোবাইল নাম্বার ১১ সংখ্যার হতে হবে');

    }else showInfo('ফর্ম পুরন করুন');
  }
}
