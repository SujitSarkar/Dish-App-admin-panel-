import 'package:admin_app/pages/login_page.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/design.dart';
import 'package:admin_app/public_variables/variables.dart';
import 'package:admin_app/subpages/all_user_list.dart';
import 'package:admin_app/subpages/paid_bill_user_list.dart';
import 'package:admin_app/subpages/pending_bill_user_list.dart';
import 'package:admin_app/subpages/user_problem_list.dart';
import 'package:admin_app/tiles/lain_man_home_tile.dart';
import 'package:admin_app/widgets/app_bar.dart';
import 'package:admin_app/widgets/routing_animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LainManHome extends StatefulWidget {
  @override
  _LainManHomeState createState() => _LainManHomeState();
}

class _LainManHomeState extends State<LainManHome> {
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.9),
              itemCount: Variables.lainManHomeMenuText.length,
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
                            child: LainManHomeMenuTile(index: index),
                            onTap: () async{
                              if (index == 0)
                                Navigator.push(
                                    context,
                                    AnimationPageRoute(
                                        navigateTo: AllUserList()));

                              else if (index == 1)
                                Navigator.push(
                                    context,
                                    AnimationPageRoute(
                                        navigateTo: PendingBillUserList()));
                              else if (index == 2)
                                Navigator.push(
                                    context,
                                    AnimationPageRoute(
                                        navigateTo: PaidBillUserList()));
                              else if (index == 3)
                                Navigator.push(
                                    context,
                                    AnimationPageRoute(
                                        navigateTo: UserProblemList()));
                              else if (index == 4){
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                pref.clear();
                                Navigator.pushAndRemoveUntil(context, AnimationPageRoute(navigateTo: LoginPage()), (route) => false);
                              }
                            },
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
