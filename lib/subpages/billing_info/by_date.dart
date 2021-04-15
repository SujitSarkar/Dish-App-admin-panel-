import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/tiles/billing_info_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BillingInfoByDate extends StatefulWidget {
  @override
  _BillingInfoByDateState createState() => _BillingInfoByDateState();
}

class _BillingInfoByDateState extends State<BillingInfoByDate> {
  DateTime _date;
  String _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
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
              Text(_selectedDate,style: Design.titleStyle(size).copyWith(color: CustomColors.liteGrey),),
            ],
          ),
        ),
      ),
      Expanded(
        child: AnimationLimiter(
          child: RefreshIndicator(
            backgroundColor: CustomColors.whiteColor,
            onRefresh: () async {},
            child: ListView.builder(
              itemCount: 16,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                          horizontalOffset: 400,
                          child: FadeInAnimation(
                            child: BillingInfoTile(index: index),
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
          _selectedDate='${_date.day}-${_date.month}-${_date.year}';
        }));
  }
}
