import 'package:admin_app/providers/lain_man_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/tiles/user_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/buttons.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class LainManList extends StatefulWidget {
  @override
  _LainManListState createState() => _LainManListState();
}

class _LainManListState extends State<LainManList> {
  bool _isObscure = true;
  int _count=0;

  void _customInit(LainManProvider lmProvider){
    lmProvider.lainManModel.phone='';
    lmProvider.lainManModel.password='';
    lmProvider.lainManModel.nID='';
    lmProvider.lainManModel.fatherName='';
    lmProvider.lainManModel.address='';
    setState(()=>_count++);
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
        child: PublicAppBar(context,'লাইন ম্যান'),
      ),
      body: _bodyUI(size, lmProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_addLainManModal(size, context, lmProvider),
        backgroundColor: CustomColors.appThemeColor,
        child: Icon(Icons.add,color: CustomColors.whiteColor,),
      ),
    );
  }

  Widget _bodyUI(Size size,LainManProvider lmProvider)=> AnimationLimiter(
    child: RefreshIndicator(
      backgroundColor: CustomColors.whiteColor,
      onRefresh: () async {},
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) =>
            AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: GestureDetector(
                          onTap: ()=>_userDetailsModal(size,context),
                          onLongPress: ()=>_deleteLainMan(),
                          child: UserTile(index: index)
                      ),
                    )
                )
            ),
      ),
    ),
  );

  void _deleteLainMan(){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'এই লাইন ম্যান কে অব্বাহুতি দিতে চান?',
          //contentText: 'content',
          onPositiveClick: () {
            Navigator.of(context).pop();
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
        );
      },
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 800),
    );
  }

  void _addLainManModal(Size size,BuildContext context,LainManProvider lmProvider){
    showModalBottomSheet(
      context: context,
      builder: (context)=> Container(
        color: CustomColors.whiteColor,
        child: Column(
          children: [
            Container(
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CustomColors.appThemeColor
              ),
              child: IconButton(
                icon: Icon(Icons.cancel_rounded,color: CustomColors.whiteColor,size: 25,),
                onPressed: ()=>Navigator.pop(context),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    color: CustomColors.whiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _textField('মোবাইল নাম্বার',
                            'assets/field-icon/icon_phone.png', size,lmProvider),
                        SizedBox(height: 10),
                        _textField('পাসওয়ার্ড',
                            "assets/field-icon/icon_password.png", size,lmProvider),
                        SizedBox(height: 10),
                        _textField('এন আইডি নাম্বার',
                            "assets/field-icon/icon_pad.png", size,lmProvider),
                        SizedBox(height: 10),
                        _textField(
                            'বাবার নাম', "assets/field-icon/icon_user.png", size,lmProvider),
                        SizedBox(height: 10),
                        _textField('বাড়ির ঠিকানা',
                            "assets/field-icon/icon_address.png", size,lmProvider),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: ()=>_formValidation(lmProvider),
                          child: shadowButton(size, 'নিবন্ধন করুন'),
                        ),
                        ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  void _userDetailsModal(Size size,BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (context)=> Container(
        color: CustomColors.whiteColor,
        child: Column(
          children: [
            Container(
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CustomColors.appThemeColor
              ),
              child: IconButton(
                icon: Icon(Icons.cancel_rounded,color: CustomColors.whiteColor,size: 25,),
                onPressed: ()=>Navigator.pop(context),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    color: CustomColors.whiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            //text: 'Hello ',
                            style: Design.subTitleStyle(size),
                            children: <TextSpan>[
                              TextSpan(text: 'নাম: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: 'ইসমাইল হোসাইন\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'মোবাইল: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '01830200087\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'বাবার নাম: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: 'আবু কাশেম\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'এন আইডি নাম্বার: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '01830200087736473739\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'বাড়ির ঠিকানা: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: 'হাউস-১৬, সোনারগাঁও জনপথ রোড, উত্তরা, ঢাকা',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                            ],
                          ),
                        )                        ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _textField(String hint, String prefixAsset, Size size,LainManProvider lmProvider) =>
      TextField(
          keyboardType:
          hint == 'মোবাইল নাম্বার' || hint == 'এন আইডি নাম্বার'
              ? TextInputType.phone
              : TextInputType.text,
          obscureText:hint == 'পাসওয়ার্ড'? _isObscure ? true : false:false,
          style: Design.subTitleStyle(size).copyWith(
            color: CustomColors.textColor,
          ),
          onChanged: (val) => hint == 'মোবাইল নাম্বার'
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
          ));

  void _formValidation(LainManProvider lmProvider){
    if(lmProvider.lainManModel.phone.isNotEmpty &&
        lmProvider.lainManModel.password.isNotEmpty &&
        lmProvider.lainManModel.nID.isNotEmpty &&
        lmProvider.lainManModel.fatherName.isNotEmpty &&
        lmProvider.lainManModel.address.isNotEmpty){
      if(lmProvider.lainManModel.phone.length==11){

      }else showInfo('মোবাইল নাম্বার ১১ সংখ্যার হতে হবে');

    }else showInfo('ফর্ম পুরন করুন');
  }
}
