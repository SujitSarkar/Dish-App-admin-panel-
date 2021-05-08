import 'package:admin_app/model/billing_info_model.dart';
import 'package:admin_app/providers/billing_provider.dart';
import 'package:admin_app/providers/user_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/tiles/billing_info_tile.dart';
import 'package:admin_app/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class BillThisMonth extends StatefulWidget {
  BillingProvider bProvider;
  BillThisMonth(this.bProvider);

  @override
  _BillThisMonthState createState() => _BillThisMonthState();
}

class _BillThisMonthState extends State<BillThisMonth> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  DateTime _date;
  List<BillingInfoModel> _billingInfoByDateList = [];
  List<BillingInfoModel> _filteredList = [];
  List<String> _userIdList = [];
  Set<String> _paidUserIdSet = Set();
  int _totalAmount=0;
  int _counter=0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  _initializeData(){
    setState(() {
      _date = DateTime.now();
      _billingInfoByDateList = widget.bProvider.approvedBillList;
      _filteredList = _billingInfoByDateList;
      _filterList('${_date.month}/${_date.year}');
    });
  }

  ///SearchList builder
  _filterList(String searchItem) {
    setState(() {
      _filteredList = _billingInfoByDateList.where((element) =>
      (element.payDate.contains(searchItem))).toList();
    });
  }

  _customInit(UserProvider userProvider)async{
    showLoadingDialog('অপেক্ষা করুন...');
    setState(()=>_counter++);
    if(userProvider.allUserList.isEmpty){
      await userProvider.getAllUser().then((value){
        for(int i=0; i<userProvider.allUserList.length;i++){
          setState(()=>_userIdList.add(userProvider.allUserList[i].id));
        }
        closeLoadingDialog();
      });
    }else{
      for(int i=0; i<userProvider.allUserList.length;i++){
        setState(()=>_userIdList.add(userProvider.allUserList[i].id));
      }
      closeLoadingDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if(_userIdList.isEmpty) _customInit(userProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      body: _bodyUI(context, size,userProvider),
    );
  }

  Widget _bodyUI(BuildContext context, Size size,UserProvider userProvider)=>Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: ()=>_pickDate(context),
            child: Container(
              margin: EdgeInsets.only(top: 5,left: 10,right: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              width: size.width*.8,
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

          PopupMenuButton<int>(
            key: _key,
            onSelected: (int val){
              if(val==1){
                _paidUserIdSet.clear();
                print('PaidUser: ${_paidUserIdSet.length}');
                _totalAmount=0;
                  int i=0;
                  while(i<_filteredList.length){
                    if(_userIdList.contains(_filteredList[i].userID)==true){
                      setState(() {
                        _paidUserIdSet.add(_filteredList[i].userID);
                      });
                      print('User: ${_userIdList.length}');
                      print('PaidUser: ${_paidUserIdSet.length}');
                    }
                      setState(()=> _totalAmount =  int.parse(_filteredList[i].amount)+_totalAmount);
                    i++;
                  }
                _showInfoDialog(size);
              }
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(child: Text('বিস্তারিত দেখুন',style: TextStyle(fontSize: size.width*.04)), value: 1,),
              ];
            },
            tooltip: 'অপশন দেখুন',
            color: Colors.white,
            offset: Offset(0,size.width*.075),
          ),
        ],
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
              itemCount: _filteredList.length,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                          horizontalOffset: 400,
                          child: FadeInAnimation(
                            child: BillingInfoTile(index: index,allBillList: _filteredList),
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

  void _showInfoDialog(Size size ){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${_date.day}/${_date.month}/${_date.year} তারিখের হিসাব',style: TextStyle(fontSize: size.width*.05),),
                SizedBox(height: size.width*.04),
                Text('মোট আদায় = $_totalAmount টাকা',style: TextStyle(fontSize: size.width*.04),),
                Text('বিল প্রদান করেছে = ${_paidUserIdSet.length} জন',style: TextStyle(fontSize: size.width*.04),),
                Text('বিল বকেয়া = ${_userIdList.length - _paidUserIdSet.length} জন',style: TextStyle(fontSize: size.width*.04),),
                //SizedBox(height: size.width*.04),
                //Text('বকেয়া বিল গ্রাহকের মোবাইল :',style: TextStyle(fontSize: size.width*.04),),
                // ListView.builder(
                //   physics: ClampingScrollPhysics(),
                //   shrinkWrap: true,
                //   itemCount: _dueBillUserIdList.length,
                //   itemBuilder: (_, index)=>GestureDetector(
                //     onTap: ()=>_makePhoneCall('tel:${_dueBillUserIdList[index]}'),
                //     child: Padding(
                //       padding:  EdgeInsets.symmetric(vertical: 5),
                //       child: Text('${_dueBillUserIdList[index]}',style: TextStyle(fontSize: size.width*.04),),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: ()=>Navigator.pop(context), child: Text('বাতিল করুন'))
          ],
        );
      },
      animationType: DialogTransitionType.slideFromTopFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    await canLaunch(url) ? launch(url) : showErrorMgs('Error making phone call. Try again later');
  }
}
