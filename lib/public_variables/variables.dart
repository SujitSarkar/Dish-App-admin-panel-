import 'package:flutter/material.dart';

class Variables {
  static final String appTitle = 'Example Dish Cable';
  static final String customerCareNumber= '01830200087\n01987354802';
  static final String officeAddress= 'House-16(A3), Sonargaon Janapath Road, Sector-12, Uttara, Dhaka';
  static final String paymentInstruction =
      'আপনার ডিস বিল টি পরিশোধ করতে প্রথমে ক্যালেন্ডার থেকে যে মাসের বিল দিতে '
      'চান সেই মাস টি চয়ন করুন। তারপর নিন্মে বর্নিত নাম্বারে আপনার \"বিকাশ\" অথবা \"রকেট\" থেকে সেন্ড-মানি করুন। '
      'সেন্ড-মানি সম্পন্ন হলে যেই নাম্বার থেকে বিল পরিশোধ করেছেন ঐ নাম্বার এবং ট্রানজেকশন আইডি '
      'প্রদান করে সম্পন্ন বাটনে প্রেস করুন।';
  static final String paymentNote =
      'আপনার বিল পরিশোধ সম্পন্ন হলে আমাদের কর্তৃপক্ষ দ্বারা '
      'তা যাচাই করা হবে। যাচাই করা সম্পন্ন হলে আপনার বিল পরিশোধ পম্পূর্ন হবে।';

  static final List<String> billType = ['ডিস বিল', 'ইন্টারনেট বিল'];

  static final List<String> homeMenuText = [
    "নতুন গ্রাহক নিবন্ধন করুন",
    "সকল গ্রাহকের তালিকা",
    "বকেয়া বিল গ্রাহকের তালিকা",
    "পরিশোধিত বিল গ্রাহকের তালিকা",
    "অনিষ্পন্ন বিলের তালিকা",
    "বিলের তথ্য",
    "গ্রাহকের সমস্যার তালিকা",
    "অফিসের ঠিকানা",
    "আমাদের সম্পর্কে",
    "লাইন ম্যান",
    "লগ আউট",
  ];

  static final List<String> lainManHomeMenuText = [
    "সকল গ্রাহকের তালিকা",
    "বকেয়া বিল গ্রাহকের তালিকা",
    "পরিশোধিত বিল গ্রাহকের তালিকা",
    "গ্রাহকের সমস্যার তালিকা",
    "লগ আউট",
  ];
  static final List<IconData> lainManHomeMenuIcon = [
    Icons.people_rounded,
    Icons.people_outline,
    Icons.people_alt_outlined,
    Icons.error_outline,
    Icons.logout,
  ];

  static final List<IconData> homeMenuIcon = [
    Icons.person_add,
    Icons.people_rounded,
    Icons.people_outline,
    Icons.people_alt_outlined,
    Icons.pending_outlined,
    Icons.info_outlined,
    Icons.error_outline,
    Icons.my_location_rounded,
    Icons.details_outlined,
    Icons.handyman_rounded,
    Icons.logout,
  ];

  static final List<String> imgList = [
    'assets/slider-image/img1.jpg',
    'assets/slider-image/img2.jpg',
    'assets/slider-image/img3.jpg',
    'assets/slider-image/img4.jpg',
    'assets/slider-image/img5.jpg',
  ];
  static List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(item, fit: BoxFit.cover, width: 500.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'No. ${imgList.indexOf(item)} image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();
}
