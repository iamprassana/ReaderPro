import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:reader_pro/utils/colors.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add),
              const SizedBox(
                height: 20,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    "Read Anytime Anywhere",
                    textStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        color: AppColors.SecondaryColor1),
                    speed: const Duration(milliseconds: 60),
                  ),
                ],
                totalRepeatCount: 2,
              )
            ]),
      ),
    );
  }
}
