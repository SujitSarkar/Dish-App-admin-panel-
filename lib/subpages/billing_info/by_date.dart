import 'package:admin_app/model/billing_info_model.dart';
import 'package:admin_app/providers/billing_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/tiles/billing_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ignore: must_be_immutable
class BillingInfoByDate extends StatefulWidget {
  BillingProvider bProvider;
  BillingInfoByDate(this.bProvider);

  @override
  _BillingInfoByDateState createState() => _BillingInfoByDateState();
}

class _BillingInfoByDateState extends State<BillingInfoByDate> {
  DateTime _date;
  List<BillingInfoModel> billingInfoByDateList = [];
  List<BillingInfoModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  _initializeData(){
    setState(() {
      _date = DateTime.now();
      billingInfoByDateList = widget.bProvider.approvedBillList;
      filteredList = billingInfoByDateList;
      _filterList('${_date.month}/${_date.year}');
    });
  }

  ///SearchList builder
  _filterList(String searchItem) {
    setState(() {
      filteredList = billingInfoByDateList.where((element) =>
      (element.monthYear.contains(searchItem))).toList();
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
      GestureDetector(
        onTap: ()=>_pickDate(context),
        child: Container(
          margin: EdgeInsets.only(top: 5,left: 10,right: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          width: size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: CustomColors.borderColor)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today_outlined,color: CustomColors.appThemeColor),
              SizedBox(width: 10),
              Text('${_date.day}/${_date.month}/${_date.year}',style: Design.titleStyle(size).copyWith(color: CustomColors.liteGrey),),
            ],
          ),
        ),
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

  void _pickDate(BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
    ).then((date)=>
        setState((){
          _date=date;
          _filterList('${_date.month}/${_date.year}');
        }));
  }
}
