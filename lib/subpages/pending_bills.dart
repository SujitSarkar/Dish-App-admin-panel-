import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/tiles/billing_info_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PendingBill extends StatefulWidget {
  @override
  _PendingBillState createState() => _PendingBillState();
}

class _PendingBillState extends State<PendingBill> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: CustomColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context, 'অনিষ্পন্ন বিলের তালিকা'),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size)=> AnimationLimiter(
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
                      child: BillingInfoTile(index: index),
                    ))),
      ),
    ),
  );
}
