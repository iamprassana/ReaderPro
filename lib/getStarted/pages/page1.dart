import 'package:flutter/material.dart';
import 'package:reader_pro/utils/colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class BackGroundPainter extends CustomPainter {
  final double animationValue;
  BackGroundPainter(this.animationValue);

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
      size.height * (0.4 + 0.06 + animationValue),
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
    path.close(); // Completes the shape

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    //Animation Controller
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat(reverse: false);

    //Animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PrimaryColor2,
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
                painter: BackGroundPainter(_animation.value),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          "Welcome To Reader Pro",
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
          );
        },
        child: Stack(
          children: [
            CustomPaint(
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              ),
              painter: BackGroundPainter(_animation.value),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        "Welcome To Reader Pro",
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
