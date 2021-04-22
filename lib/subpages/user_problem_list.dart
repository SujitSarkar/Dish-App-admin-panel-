import 'package:admin_app/providers/user_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/tiles/problem_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class UserProblemList extends StatefulWidget {
  @override
  _UserProblemListState createState() => _UserProblemListState();
}

class _UserProblemListState extends State<UserProblemList> {

  int _counter=0;
  _customInit(UserProvider uProvider)async{
    showLoadingDialog('অপেক্ষা করুন...');
    setState(()=>_counter++);
    await uProvider.checkConnectivity();
    await uProvider.getUserProblem().then((value){
      if(value==true) closeLoadingDialog();
      else{
        closeLoadingDialog();
        showErrorMgs('ডেটা লোড অসম্পন্ন হয়েছে! আবার চেষ্টা করুন।');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    final UserProvider uProvider = Provider.of<UserProvider>(context);
    if(_counter==0) _customInit(uProvider);

    return Scaffold(
      backgroundColor: CustomColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context, 'গ্রাহকের সমস্যার তালিকা'),
      ),
      body: uProvider.internetConnected==true? _bodyUI(size,uProvider):NoInternet(uProvider),
    );
  }

  Widget _bodyUI(Size size,UserProvider uProvider) => AnimationLimiter(
    child: RefreshIndicator(
      backgroundColor: CustomColors.whiteColor,
      onRefresh: () async {await uProvider.getUserProblem();},
      child: ListView.builder(
        itemCount: uProvider.userProblemList.length,
        itemBuilder: (context, index) =>
            AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: ()=> _solveUserProblemDialog(uProvider, uProvider.userProblemList[index].id),
                          child: ProblemTile(index: index,problemList:  uProvider.userProblemList)),
                    ))),
      ),
    ),
  );

  void _solveUserProblemDialog(UserProvider uProvider, String id){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'এই গ্রাহকের সমস্যা সমাধান করেছেন?',
          //contentText: 'content',
          onPositiveClick: () async{
            await uProvider.checkConnectivity().then((value)async{
              if(uProvider.internetConnected==true){
                showLoadingDialog('অপেক্ষা করুন...');
                await FirebaseFirestore.instance.collection('UserProblems').doc(id).update({
                  'state': 'yes'
                }).then((value)async{
                  await uProvider.getUserProblem();
                  closeLoadingDialog();
                  Navigator.pop(context);
                },onError: (error){
                  closeLoadingDialog();
                  showErrorMgs(error.toString());
                  Navigator.pop(context);
                });
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
