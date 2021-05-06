import 'package:admin_app/model/lain_man_model.dart';
import 'package:admin_app/providers/lain_man_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/subpages/add_lainman.dart';
import 'package:admin_app/tiles/lain_man_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:admin_app/widgets/routing_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class LainManList extends StatefulWidget {
  @override
  _LainManListState createState() => _LainManListState();
}

class _LainManListState extends State<LainManList> {
  int _count=0;

  void _customInit(LainManProvider lmProvider)async{
    showLoadingDialog('অপেক্ষা করুন...');
    setState(()=>_count++);
    await lmProvider.checkConnectivity();
    await lmProvider.getAllLainMan().then((value){
      if(value==true) closeLoadingDialog();
      else{
        closeLoadingDialog();
        showErrorMgs('ডেটা লোড অসম্পন্ন!\n আবার চেষ্টা করুন');
      }
    },onError: (error){
      closeLoadingDialog();
      showErrorMgs(error.toString());
    });
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
        child: PublicAppBar(context,'সকল লাইনম্যান এর তালিকা'),
      ),
      body: lmProvider.internetConnected==true?_bodyUI(size, lmProvider):NoInternet(lmProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, AnimationPageRoute(navigateTo: AddLainMan())),
        backgroundColor: CustomColors.appThemeColor,
        child: Icon(Icons.add,color: CustomColors.whiteColor,),
      ),
    );
  }

  Widget _bodyUI(Size size,LainManProvider lmProvider)=> AnimationLimiter(
    child: RefreshIndicator(
      backgroundColor: CustomColors.whiteColor,
      onRefresh: () async {await lmProvider.getAllLainMan();},
      child: ListView.builder(
        itemCount: lmProvider.lainManList.length,
        itemBuilder: (context, index) =>
            AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: GestureDetector(
                          onTap: ()=>_lainManDetailsModal(size,context,index,lmProvider.lainManList),
                          onLongPress: ()=>_deleteLainMan(lmProvider.lainManList[index].id, index,lmProvider),
                          child: LainManTile(index: index,lainManList: lmProvider.lainManList)
                      ),
                    )
                )
            ),
      ),
    ),
  );

  void _deleteLainMan(String id, int index,LainManProvider lmProvider){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'এই লাইন ম্যান কে অব্বাহুতি দিতে চান?',
          positiveText: 'হ্যাঁ',
          negativeText: 'না',
          //contentText: 'content',
          onPositiveClick: () async{
            lmProvider.checkConnectivity().then((value)async{
              if(lmProvider.internetConnected==true){
                showLoadingDialog('অপেক্ষা করুন...');
                await lmProvider.deleteLainMan(id, index).then((value){
                  if(value==true){
                    closeLoadingDialog();
                    showSuccessMgs('লাইন ম্যান অব্বাহুতি সম্পন্ন হয়েছে');
                    Navigator.of(context).pop();
                  }else{
                    closeLoadingDialog();
                    showErrorMgs('লাইন ম্যান অব্বাহুতি অসম্পন্ন হয়েছে!\nআবার চেষ্টা করুন');
                    Navigator.of(context).pop();
                  }
                });
              }else{
                showInfo('কোনও ইন্টারনেট সংযোগ নেই!');
              }
            },onError: (error)=>showInfo(error.toString()));
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
        );
      },
      animationType: DialogTransitionType.slideFromTopFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 800),
    );
  }

  void _lainManDetailsModal(Size size,BuildContext context,int index, List<LainManModel> lainManList){
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
                            style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey),
                            children: <TextSpan>[
                              TextSpan(text: 'নাম: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${lainManList[index].name}\n\n'),

                              TextSpan(text: 'মোবাইল: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${lainManList[index].phone}\n\n'),

                              TextSpan(text: 'পাসওয়ার্ড: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${lainManList[index].password}\n\n'),

                              TextSpan(text: 'বাবার নাম: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${lainManList[index].fatherName}\n\n'),

                              TextSpan(text: 'এন আইডি নাম্বার: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${lainManList[index].nID}\n\n'),

                              TextSpan(text: 'বাড়ির ঠিকানা: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '${lainManList[index].address}'),

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
