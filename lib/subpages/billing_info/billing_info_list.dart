import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/subpages/billing_info/by_date.dart';
import 'package:admin_app/subpages/billing_info/by_user.dart';
import 'package:flutter/material.dart';

class BillingInfo extends StatefulWidget {
  @override
  _BillingInfoState createState() => _BillingInfoState();
}

class _BillingInfoState extends State<BillingInfo> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2,vsync: this);
  }
  
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: AppBar(
        title: Text('বিলের তথ্য'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'তারিখ অনুযায়ী'),
            Tab(text: 'ক্রেতা অনুযায়ী')
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BillingInfoByDate(),
          BillingInfoByUser()
        ],
      ),
    );
  }




}
