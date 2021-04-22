import 'package:admin_app/providers/public_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/buttons.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  TextEditingController _aboutController=TextEditingController();
  TextEditingController _serviceController=TextEditingController();
  String _id='';
  int _counter=0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  void _initializeData()async{
    showLoadingDialog('অপেক্ষা করুন...');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('OfficeDetails').get();
    final List<QueryDocumentSnapshot> addressSnapshot = snapshot.docs;
    if(addressSnapshot.isNotEmpty){
      _aboutController.text = addressSnapshot[0].get('aboutUs')??'';
      _serviceController.text = addressSnapshot[0].get('ourService')??'';
      _id = addressSnapshot[0].get('id');
      closeLoadingDialog();
    }else{
      closeLoadingDialog();
      showErrorMgs('সমস্যা হচ্ছে!\nএকটু পর আবার চেষ্টা করুন');
    }
  }

  void _customInit(PublicProvider pProvider)async{
    setState(()=> _counter++);
    await pProvider.checkConnectivity();
  }
  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);
    if(_counter==0) _customInit(pProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context,'আমাদের সম্পর্কে'),
      ),
      body: pProvider.internetConnected==true? _bodyUI(size,pProvider):NoInternet(pProvider),
    );
  }

  Widget _bodyUI(Size size,PublicProvider pProvider)=> Column(
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
              _textField('আমাদের সম্পর্কে',size),
              _textField('আমাদের সার্ভিস',size),
              SizedBox(height: 12),

              GestureDetector(
                onTap: ()async{
                  await pProvider.checkConnectivity().then((value){
                    if(pProvider.internetConnected==true){
                      _checkValidity(pProvider);
                    }else{
                      showErrorMgs('কোনও ইন্টারনেট সংযোগ নেই!');
                    }
                  });
                },
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
            controller: hint=='আমাদের সম্পর্কে'? _aboutController:_serviceController,
            textCapitalization:TextCapitalization.sentences,
            keyboardType:TextInputType.text,
            maxLines: 10,
            textAlign: TextAlign.justify,
            style: Design.subTitleStyle(size).copyWith(
              color: CustomColors.textColor,
            ),
            decoration: Design.loginFormDecoration.copyWith(
                hintText: hint,
                labelText: hint
            )),
      );

  void _checkValidity(PublicProvider pProvider)async{
      if(_aboutController.text.isNotEmpty || _serviceController.text.isNotEmpty){
        showLoadingDialog('অপেক্ষা করুন...');

        await pProvider.updateAboutUs(_id, _aboutController.text,_serviceController.text).then((value){
          if(value==true){
            closeLoadingDialog();
            showSuccessMgs('পরিবর্তন সফল হয়েছে');
            Navigator.pop(context);
          }else{
            closeLoadingDialog();
            showErrorMgs('পরিবর্তন সফল হয়নি!\nআবার চেষ্টা করুন');
          }
        },onError: (error){
          closeLoadingDialog();
          showErrorMgs(error.toString());
        });
      }else showInfo('আপনাদের সম্পর্কে অথবা সার্ভিস লিখুন ');


  }
}

