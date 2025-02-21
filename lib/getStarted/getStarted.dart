// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:reader_pro/getStarted/pages/page1.dart';
import 'package:reader_pro/getStarted/pages/page2.dart';
import 'package:reader_pro/getStarted/pages/page3.dart';
import 'package:reader_pro/mainScreen/mainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:reader_pro/utils/colors.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  final PageController _controller = PageController();
  bool isLast = false;

  Future<void> setPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isGetStarted', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLast = (index == 2);
              });
            },
            children: [
              Page1(),
              Page2(),
              Page3(),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 50,
            left: 0,
            child: Container(
              alignment: Alignment(0, 0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Dot Indicator
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: WormEffect(),
                      ),
                      const SizedBox(height: 50),
                      //Skip Text

                      !isLast
                          ? GestureDetector(
                              onTap: () {
                                _controller.jumpToPage(2);
                              },
                              child: Text("Skip"),
                            )
                          : Text(""),
                      const SizedBox(height: 10),

                      //Let's Read Text Button
                      isLast
                          ? GestureDetector(
                              onTap: () {
                                // setPref(); -- TODO() enable before production
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPage(),
                                  ),
                                );
                              },
                              child: Text("Let's Read"))
                          : Text("")
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
