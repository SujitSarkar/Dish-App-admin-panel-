import 'package:admin_app/providers/public_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/buttons.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OfficeAddress extends StatefulWidget {

  @override
  _OfficeAddressState createState() => _OfficeAddressState();
}

class _OfficeAddressState extends State<OfficeAddress> {
  TextEditingController _addressController=TextEditingController();
  TextEditingController _customerCareController=TextEditingController();
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
      _addressController.text = addressSnapshot[0].get('address')??'';
      _customerCareController.text =  addressSnapshot[0].get('customerCare')??'';
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
        child: PublicAppBar(context,'অফিসের ঠিকানা'),
      ),
      body: _bodyUI(size,pProvider),
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
              _textField('অফিসের ঠিকানা',size),
              _textField('গ্রাহক সেবা নাম্বার',size),

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
          controller: hint == 'অফিসের ঠিকানা'? _addressController:_customerCareController,
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
            decoration: Design.loginFormDecoration.copyWith(
              hintText: hint,
              labelText: hint
            )),
      );
  
  void _checkValidity(PublicProvider pProvider)async{
    if(_addressController.text.isNotEmpty){
      if(_customerCareController.text.isNotEmpty){
        showLoadingDialog('অপেক্ষা করুন...');
        Map<String, String> _dataMap= {
          'address': _addressController.text,
          'customerCare': _customerCareController.text,
        };
        await pProvider.updateAddressAndCustomerCare(_id, _dataMap).then((value){
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
      }else showInfo('গ্রাহক সেবার নাম্বার প্রদান করুন');
    }else showInfo('অফিসের ঠিকানা প্রদান করুন');

  }
}
