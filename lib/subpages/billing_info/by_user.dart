import 'package:admin_app/model/billing_info_model.dart';
import 'package:admin_app/providers/billing_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/tiles/billing_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ignore: must_be_immutable
class BillingInfoByUser extends StatefulWidget {
  BillingProvider bProvider;
  BillingInfoByUser(this.bProvider);

  @override
  _BillingInfoByUserState createState() => _BillingInfoByUserState();
}

class _BillingInfoByUserState extends State<BillingInfoByUser> {
  List<BillingInfoModel> billingInfoByDateList = [];
  List<BillingInfoModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData(){
    setState(() {
      billingInfoByDateList = widget.bProvider.approvedBillList;
      filteredList = billingInfoByDateList;
    });
  }

  ///SearchList builder
  _filterList(String searchItem) {
    setState(() {
      filteredList = billingInfoByDateList.where((element) =>
      (element.name.toLowerCase().contains(searchItem.toLowerCase()))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      body: _bodyUI(context, size),
    );
  }

  Widget _bodyUI(BuildContext context, Size size)=>Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: 5,left: 10,right: 10),
        height: 50,
        child: TextField(
            keyboardType:TextInputType.text,
            style: Design.subTitleStyle(size).copyWith(
              color: CustomColors.textColor,
            ),
            onChanged: _filterList,
            decoration: Design.loginFormDecoration.copyWith(
              hintText: 'অনুসন্ধান করুন...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/field-icon/icon_search.png',
                  width: 15,
                  height: 15,
                ),
              ),
            )),
      ),
      Expanded(
        child: AnimationLimiter(
          child: RefreshIndicator(
            backgroundColor: CustomColors.whiteColor,
            onRefresh: () async {
              await widget.bProvider.getApprovedBillingInfo();
              _initializeData();
              },
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                          horizontalOffset: 400,
                          child: FadeInAnimation(
                            child: BillingInfoTile(index: index,allBillList: filteredList),
                          )
                      )
                  ),
            ),
          ),
        ),
      )
    ],
  );

}
