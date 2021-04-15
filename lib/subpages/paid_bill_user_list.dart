import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/tiles/user_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PaidBillUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context,'পরিশোধিত বিল গ্রাহকের তালিকা'),
      ),
      body: _bodyUI(size,context),
    );
  }

  Widget _bodyUI(Size size,BuildContext context)=>AnimationLimiter(
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
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: GestureDetector(
                          onTap: ()=>_userDetailsModal(size,context),
                          child: UserTile(index: index)
                      ),
                    )
                )
            ),
      ),
    ),
  );

  void _userDetailsModal(Size size,BuildContext context){
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
                              TextSpan(text: 'ইসমাইল হোসাইন\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'মোবাইল: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '01830200087\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'বাবার নাম: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: 'আবু কাশেম\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'এন আইডি নাম্বার: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: '01830200087736473739\n\n',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

                              TextSpan(text: 'বাড়ির ঠিকানা: ',style: Design.subTitleStyle(size).copyWith(fontWeight: FontWeight.bold,color: CustomColors.liteGrey)),
                              TextSpan(text: 'হাউস-১৬, সোনারগাঁও জনপথ রোড, উত্তরা, ঢাকা',style: Design.subTitleStyle(size).copyWith(color: CustomColors.liteGrey)),

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
