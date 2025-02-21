import 'package:flutter/material.dart';
import 'package:reader_pro/utils/colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PrimaryColor2,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            const SizedBox(
              height: 20,
            ),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  "Welcome To Reader Pro",
                  textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      color: AppColors.SecondaryColor1),
                  speed: const Duration(milliseconds: 60),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ],
        ),
      ),
    );
  }
}
