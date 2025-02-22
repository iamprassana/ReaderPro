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

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BackGroundPaint oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false); // Loop animation

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller to free resources
    super.dispose();
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
              /// **1. Animated Background**
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
                          "Start Your Reading Journey",
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
      ),
    );
  }
}
