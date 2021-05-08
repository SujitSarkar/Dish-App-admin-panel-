import 'package:admin_app/model/user_model.dart';
import 'package:admin_app/providers/billing_provider.dart';
import 'package:admin_app/providers/user_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/tiles/user_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AllUserList extends StatefulWidget {


  @override
  _AllUserListState createState() => _AllUserListState();
}

class _AllUserListState extends State<AllUserList> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  int _counter=0;
  String _info='';

  _customInit(UserProvider uProvider)async{
    showLoadingDialog('অপেক্ষা করুন...');
    setState(()=>_counter++);
    await uProvider.checkConnectivity();
    await uProvider.getAllUser().then((value){
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
      appBar: AppBar(
        title: Text('সকল গ্রাহকের তালিকা'),
        actions: [
          PopupMenuButton<int>(
            key: _key,
            onSelected: (int val){
              if(val==1){
                setState(()=> _info = 'মোট গ্রাহক সংখ্যা ${uProvider.allUserList.length} জন');
                _showInfoDialog();
              }else if(val==2){
                setState(()=> _info = 'মোট লাইন সংখ্যা ${uProvider.allUserList.length} টি');
                _showInfoDialog();
              }
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(child: Text('মোট গ্রাহক সংখ্যা',style: TextStyle(fontSize: size.width*.04)), value: 1,),
                PopupMenuItem(child: Text('মোট লাইন সংখ্যা',style: TextStyle(fontSize: size.width*.04)), value: 2),
              ];
            },
            tooltip: 'অপশন দেখুন',
            color: Colors.white,
            offset: Offset(0,size.width*.075),
          ),
        ],
      ),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60),
      //   child: PublicAppBar(context,'সকল গ্রাহকের তালিকা'),
      // ),
      body: uProvider.internetConnected==true? _bodyUI(size,context,uProvider):NoInternet(uProvider),
    );
  }

  Widget _bodyUI(Size size,BuildContext context,UserProvider uProvider)=>AnimationLimiter(
    child: RefreshIndicator(
      backgroundColor: CustomColors.whiteColor,
      onRefresh: () async {await uProvider.getAllUser();},
      child: ListView.builder(
        itemCount: uProvider.allUserList.length,
        itemBuilder: (context, index) =>
            AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: GestureDetector(
                          onTap: ()=>_userDetailsModal(size,context,index,uProvider.allUserList),
                          onLongPress: (){
                            _deleteUserConfirmationDialog(uProvider, uProvider.allUserList[index].id);
                          },
                          child: UserTile(index: index,userList: uProvider.allUserList)
                      ),
                    )
                )
            ),
      ),
    ),
  );

  void _deleteUserConfirmationDialog(UserProvider uProvider, String userID){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'এই গ্রাহক কে ডিলিট করতে চান?',
          //contentText: 'content',
          onPositiveClick: () async{
            await uProvider.checkConnectivity().then((value)async{
              if(uProvider.internetConnected==true){
                showLoadingDialog('অপেক্ষা করুন...');
                uProvider.deleteUser(userID);
                Navigator.pop(context);
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

  void _showInfoDialog(){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: '$_info',

          onNegativeClick: ()=> Navigator.of(context).pop(),
          negativeText: 'বাতিল করুন',
        );
      },
      animationType: DialogTransitionType.slideFromTopFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

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

                              TextSpan(text: 'পিতা/স্বামী: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${userList[index].fatherName}\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'লাইন নাম্বার: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
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
}

