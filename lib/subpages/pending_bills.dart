import 'package:admin_app/model/billing_info_model.dart';
import 'package:admin_app/providers/billing_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/tiles/billing_info_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class PendingBill extends StatefulWidget {
  @override
  _PendingBillState createState() => _PendingBillState();
}

class _PendingBillState extends State<PendingBill> {

  int _counter=0;
  _customInit(BillingProvider bProvider)async{
    showLoadingDialog('অপেক্ষা করুন...');
    setState(()=>_counter++);
    await bProvider.checkConnectivity();
    await bProvider.getPendingBillingInfo().then((value){
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
    final BillingProvider bProvider = Provider.of<BillingProvider>(context);
    if(_counter==0) _customInit(bProvider);
    return Scaffold(
      backgroundColor: CustomColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context, 'অনিষ্পন্ন বিলের তালিকা'),
      ),
      body: bProvider.internetConnected==true? _bodyUI(size,bProvider):NoInternet(bProvider),
    );
  }

  Widget _bodyUI(Size size,BillingProvider bProvider)=> AnimationLimiter(
    child: RefreshIndicator(
      backgroundColor: CustomColors.whiteColor,
      onRefresh: () async {await bProvider.getPendingBillingInfo();},
      child: ListView.builder(
        itemCount: bProvider.pendingBillList.length,
        itemBuilder: (context, index) =>
            AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: ()=> _approveBillConfirmationDialog(bProvider,index,bProvider.pendingBillList),
                          child: BillingInfoTile(index: index,allBillList:  bProvider.pendingBillList)),
                    ))),
      ),
    ),
  );

  void _approveBillConfirmationDialog(BillingProvider bProvider,int index,List<BillingInfoModel> billList){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'বিল টি অনুমোদিত করতে চান?',
          //contentText: 'content',
          onPositiveClick: () async{
            await bProvider.checkConnectivity().then((value)async{
              if(bProvider.internetConnected==true){
                showLoadingDialog('অপেক্ষা করুন...');
                await bProvider.approveUserBill(billList[index].id, billList[index].userID).then((value){
                  if(value==true){
                    closeLoadingDialog();
                    showSuccessMgs('অনুমোদন সফল হয়েছে');
                    Navigator.pop(context);
                  }else{
                    closeLoadingDialog();
                    showErrorMgs('অনুমোদন ব্যর্থ হয়েছে!\nআবার চেষ্টা করুন');
                    Navigator.pop(context);
                  }
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
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
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
