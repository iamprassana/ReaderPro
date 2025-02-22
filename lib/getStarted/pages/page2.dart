import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:reader_pro/utils/colors.dart';

class BackGroundPaint extends CustomPainter {
  final double animationValue;
  BackGroundPaint(this.animationValue);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.PrimaryColor1
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * (0.3 + 0.06 + animationValue));
    path.quadraticBezierTo(
      size.width / 4,
      size.height * (0.4 + 0.05 + animationValue),
      size.width / 2,
      size.height * (0.3 - 0.06 + animationValue),
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * (0.2 + 0.05 + animationValue),
      size.width,
      size.height * (0.3 - 0.06 + animationValue),
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint); // ← This was missing!
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PrimaryColor2,
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Center(
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                  ),
                  painter: BackGroundPaint(_animation.value),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            "Read Anytime Anywhere",
                            textStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 30,
                              color: AppColors.SecondaryColor2,
                            ),
                            speed: const Duration(milliseconds: 60),
                          ),
                        ],
                        totalRepeatCount: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        child: Stack(
          children: [
            /// **1. Background**
            CustomPaint(
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              ),
              painter: BackGroundPaint(_animation.value),
            ),

            /// **2. Content**
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        "Read Anytime Anywhere",
                        textStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          color: AppColors.SecondaryColor1,
                        ),
                        speed: const Duration(milliseconds: 60),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
