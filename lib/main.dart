import 'package:admin_app/pages/home_page.dart';
import 'package:admin_app/providers/lain_man_provider.dart';
import 'package:admin_app/providers/public_provider.dart';
import 'package:admin_app/providers/user_provider.dart';
import 'package:admin_app/public_variables/colors.dart';
import 'package:admin_app/public_variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 3000) //display duration of [showSuccess] [showError] [showInfo], default 2000ms.
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = CustomColors.whiteColor
      ..backgroundColor = CustomColors.blackColor.withOpacity(0.75)
      ..indicatorColor = CustomColors.whiteColor
      ..textColor = CustomColors.whiteColor
      ..maskColor = CustomColors.appThemeColor.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>PublicProvider()),
        ChangeNotifierProvider(create: (context)=>UserProvider()),
        ChangeNotifierProvider(create: (context)=>LainManProvider()),
      ],
      child: MaterialApp(
        title: Variables.appTitle,
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff0095B2, CustomColors.themeMapColor),
          canvasColor: Colors.transparent,
        ),
        home: HomePage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

