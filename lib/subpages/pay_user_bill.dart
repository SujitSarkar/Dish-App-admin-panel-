import 'package:admin_app/providers/user_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/public_variables/variables.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/buttons.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PayUserBill extends StatefulWidget {
  String name;
  String userPhone;
  String userID;

  PayUserBill({this.name, this.userPhone, this.userID});

  @override
  _PayUserBillState createState() => _PayUserBillState();
}

class _PayUserBillState extends State<PayUserBill> {
  int _counter=0;
  String _billType;
  DateTime _date;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  _customInit(UserProvider uProvider)async{
    setState(()=>_counter++);
    await uProvider.checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserProvider uProvider = Provider.of<UserProvider>(context);
    if(_counter==0) _customInit(uProvider);
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context,'${widget.name}'),
      ),
      body:uProvider.internetConnected==true? _bodyUI(size,uProvider):NoInternet(uProvider),
    );
  }

  Widget _bodyUI(Size size, UserProvider uProvider)=> SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: size.width*.05),
          ///Form Section
          Container(
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: Design.borderRadius,
                gradient: CustomColors.whiteGradientColor,
                boxShadow: [Design.cardShadow]),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///Date picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        width: size.width * .1,
                        child: InkWell(
                          onTap: ()=> _pickDate(),
                          borderRadius: Design.buttonRadius,
                          splashColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.calendar_today_outlined,
                              color: Theme.of(context).primaryColor,
                              size: size.width * .075),
                        ),
                      ),
                      Container(
                        width: size.width * .78,
                        child: _textField('তারিখ', size),
                      ),
                    ],
                  ),
                  SizedBox(height: size.width * .04),

                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _billType,
                      isExpanded: true,
                      hint: Text("বিলের বিবরণ",style: TextStyle(
                          color: CustomColors.liteGrey,
                          fontSize: size.width*.04)),
                      items: Variables.billType.map((category){
                        return DropdownMenuItem(
                          child: Text(category,style: TextStyle(
                            color: CustomColors.textColor,
                            fontSize: size.width*.04,)),
                          value: category,
                        );
                      }).toList(),
                      onChanged: (newValue)=> setState(() => _billType = newValue),
                      dropdownColor: CustomColors.whiteColor,
                    ),
                  ),
                  Divider(height: 0,thickness: 1,color: CustomColors.liteGrey2),
                  SizedBox(height: size.width * .03),


                  _textField('বিলের পরিমান', size),
                  SizedBox(height: size.width * .04),

                  InkWell(
                    onTap: ()async{
                      await uProvider.checkConnectivity().then((value){
                        if(uProvider.internetConnected==true) _formValidation(uProvider);
                        else showErrorMgs('কোনও ইন্টারনেট সংযোগ নেই');
                      },onError: (error)=>showErrorMgs(error.toString()));
                    },
                    child: smallGradientButton(context, 'নিশ্চিত করুন'),
                    borderRadius: Design.buttonRadius,
                    splashColor: Theme.of(context).primaryColor,
                  ),
                  //SizedBox(height: size.width*.04),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );

  void _formValidation(UserProvider uProvider)async{
    if(_dateController.text.isNotEmpty){
      if(_billType!=null){
        if(_amountController.text.isNotEmpty){
          showLoadingDialog('অপেক্ষা করুন...');
          await uProvider.payUserBill(_date,_billType,widget.userPhone,widget.userID,widget.name,_amountController.text).then((success)async{
            if(success==true){
              await uProvider.getPendingBillUser();
              closeLoadingDialog();
              showSuccessMgs('বিল প্রদান সম্পন্ন হয়েছে');
              Navigator.pop(context);
            }else{
              closeLoadingDialog();
              showErrorMgs('বিল প্রদান অসম্পন্ন হয়েছে!');
            }
          },onError: (error){
            closeLoadingDialog();
            showErrorMgs(error.toString());
          });
        }else showInfo(
            'বিলের পরিমান নিশ্চিত করুন');

        } else
          showInfo(
              'বিলের বিবরণ নিশ্চিত করুন');
    }else
      showInfo(
          'বিলের মাস নিশ্চিত করুন');
  }

  void _pickDate(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
    ).then((date)=>
        setState((){
          _date=date;
          _dateController.text='${_date.day}-${_date.month}-${_date.year}';
        }));
  }

  TextFormField _textField(String hint, Size size) => TextFormField(
    readOnly: hint == 'তারিখ' ?true:false,
    onTap: ()=> hint=='তারিখ'?_pickDate():null,
    controller:
    hint == 'তারিখ' ? _dateController
        :  _amountController,
    keyboardType:  hint == 'বিলের পরিমান'
        ? TextInputType.number
        : TextInputType.text,
    decoration: Design.formDecoration(size).copyWith(labelText: hint),
  );
}
