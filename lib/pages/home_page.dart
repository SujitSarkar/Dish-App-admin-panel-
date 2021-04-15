import 'package:admin_app/pages/login_page.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/public_variables/variables.dart';
import 'package:admin_app/subpages/about_us.dart';
import 'package:admin_app/subpages/add_new_user.dart';
import 'package:admin_app/subpages/all_user_list.dart';
import 'package:admin_app/subpages/billing_info/billing_info_list.dart';
import 'package:admin_app/subpages/lain_man_list.dart';
import 'package:admin_app/subpages/office_address.dart';
import 'package:admin_app/subpages/paid_bill_user_list.dart';
import 'package:admin_app/subpages/pending_bill_user_list.dart';
import 'package:admin_app/subpages/pending_bills.dart';
import 'package:admin_app/subpages/user_problem_list.dart';
import 'package:admin_app/tiles/home_grid_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/routing_animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: PublicAppBar(context, Variables.appTitle)),
      body: _bodyUI(),
    );
  }

  Widget _bodyUI() {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        ///Image Slider
        Container(
          height: size.width * .5,
          width: size.width,
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            items: Variables.imageSliders,
          ),
        ),

        ///GridView
        Expanded(
          child: AnimationLimiter(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.9
                  ),
              itemCount: Variables.homeMenuText.length,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        verticalOffset: 400,
                        child: FadeInAnimation(
                          child: InkWell(
                            borderRadius: Design.borderRadius,
                            splashColor: Theme.of(context).primaryColor,
                              child: HomeMenuTile(index: index),
                            onTap: () =>
                            index == 0
                                ? Navigator.push(context, AnimationPageRoute(
                                navigateTo: AddNewUser()))
                                : index == 1
                                ? Navigator.push(context,
                                AnimationPageRoute(navigateTo: AllUserList()))
                                : index == 2
                                ? Navigator.push(context,
                                AnimationPageRoute(navigateTo: PendingBillUserList()))
                                : index == 3
                                ? Navigator.push(context,
                                AnimationPageRoute(navigateTo: PaidBillUserList()))
                                : index == 4
                                ? Navigator.push(context,
                                AnimationPageRoute(navigateTo: PendingBill()))
                                : index == 5
                                ? Navigator.push(context,
                                AnimationPageRoute(navigateTo: BillingInfo()))
                                : index == 6
                                ? Navigator.push(context,
                                AnimationPageRoute(navigateTo: UserProblemList()))
                                : index == 7
                                ? Navigator.push(context,
                                AnimationPageRoute(navigateTo: OfficeAddress()))
                                : index == 8
                                ? Navigator.push(context,
                                AnimationPageRoute(navigateTo: AboutUs()))
                                : index == 9
                                ? Navigator.push(context,
                                AnimationPageRoute(navigateTo: LainManList()))
                                : Navigator.push(context,
                                AnimationPageRoute(navigateTo: LoginPage())),
                          ),
                        ),
                      )),
            ),
          ),
        ),
      ],
    );
  }
}
