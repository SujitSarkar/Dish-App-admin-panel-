import 'package:admin_app/providers/billing_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/subpages/billing_info/by_date.dart';
import 'package:admin_app/subpages/billing_info/by_user.dart';
import 'package:admin_app/widgets/no_internet.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillingInfo extends StatefulWidget {
  @override
  _BillingInfoState createState() => _BillingInfoState();
}

class _BillingInfoState extends State<BillingInfo> with SingleTickerProviderStateMixin{

  TabController _tabController;

  int _counter=0;
  _customInit(BillingProvider bProvider)async{
    showLoadingDialog('অপেক্ষা করুন...');
    setState(()=>_counter++);
    await bProvider.checkConnectivity();
    await bProvider.getApprovedBillingInfo().then((value){
      if(value==true) closeLoadingDialog();
      else{
        closeLoadingDialog();
        showErrorMgs('ডেটা লোড অসম্পন্ন হয়েছে! আবার চেষ্টা করুন।');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2,vsync: this);
  }
  
  @override
  Widget build(BuildContext context) {
    final BillingProvider bProvider = Provider.of<BillingProvider>(context);
    if(_counter==0) _customInit(bProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: AppBar(
        title: Text('বিলের তথ্য'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'গ্রাহক অনুযায়ী'),
            Tab(text: 'মাস অনুযায়ী'),
          ],
        ),
      ),
      body: bProvider.internetConnected==true? TabBarView(
        controller: _tabController,
        children: [
          BillingInfoByUser(bProvider),
          BillingInfoByDate(bProvider),
        ],
      ):NoInternet(bProvider),
    );
  }




}
