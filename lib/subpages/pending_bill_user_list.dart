import 'package:admin_app/model/user_model.dart';
import 'package:admin_app/providers/user_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/subpages/pay_user_bill.dart';
import 'package:admin_app/tiles/user_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:admin_app/widgets/routing_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class PendingBillUserList extends StatefulWidget {

  @override
  _PendingBillUserListState createState() => _PendingBillUserListState();
}

class _PendingBillUserListState extends State<PendingBillUserList> {
  int _counter=0;

  _customInit(UserProvider uProvider)async{
    showLoadingDialog('অপেক্ষা করুন...');
    setState(()=>_counter++);
    await uProvider.checkConnectivity();
    await uProvider.getPendingBillUser().then((value){
      if(value==true) closeLoadingDialog();
      else{
        closeLoadingDialog();
        showErrorMgs('ডেটা লোড অসম্পন্ন হয়েছে! আবার চেষ্টা করুন।');
      }
    });
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
        child: PublicAppBar(context,'বকেয়া বিল গ্রাহকের তালিকা'),
      ),
      body:uProvider.internetConnected==true? _bodyUI(size,context,uProvider):NoInternet(uProvider),
    );
  }

  Widget _bodyUI(Size size,BuildContext context,UserProvider uProvider)=>AnimationLimiter(
    child: RefreshIndicator(
      backgroundColor: CustomColors.whiteColor,
      onRefresh: () async {await uProvider.getPendingBillUser();},
      child: ListView.builder(
        itemCount: uProvider.pendingBillUserList.length,
        itemBuilder: (context, index) =>
            AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onLongPress: ()=> _payUserBillConfirmationDialog(
                            uProvider,
                            uProvider.pendingBillUserList[index].name,
                          uProvider.pendingBillUserList[index].phone,
                          uProvider.pendingBillUserList[index].id,
                        ),
                          onTap: ()=>_userDetailsModal(size,context,index,uProvider.pendingBillUserList),
                          child: UserTile(index: index,userList:  uProvider.pendingBillUserList,)
                      ),
                    )
                )
            ),
      ),
    ),
  );

  void _userDetailsModal(Size size,BuildContext context,int index, List<UserModel> userList){
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
                              TextSpan(text: '${userList[index].name}\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'মোবাইল: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${userList[index].phone}\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'বাবার নাম: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${userList[index].fatherName}\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'এন আইডি নাম্বার: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${userList[index].nID}\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'বাড়ির ঠিকানা: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${userList[index].address}',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

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

  void _payUserBillConfirmationDialog(UserProvider uProvider, String name,String userPhone, String userID){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'এই গ্রাহকের বিল প্রদান করতে চান?',
          //contentText: 'content',
          onPositiveClick: () async{
            await uProvider.checkConnectivity().then((value)async{
              if(uProvider.internetConnected==true){
                Navigator.pop(context);
                Navigator.push(context, AnimationPageRoute(navigateTo: PayUserBill(name: name,userPhone: userPhone,userID: userID)));
              }else{
                showErrorMgs('কোনও ইন্টারনেট সংযোগ নেই!');
                Navigator.pop(context);
              }
            });
          },
          onNegativeClick: ()=> Navigator.of(context).pop(),
          positiveText: 'হ্যাঁ',
          negativeText: 'না',
        );
      },
      animationType: DialogTransitionType.slideFromTopFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }
}
