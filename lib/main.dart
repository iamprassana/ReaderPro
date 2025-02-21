import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reader_pro/getStarted/getStarted.dart';
import 'package:reader_pro/mainScreen/mainPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  bool isViewed = pref.getBool('isGetStarted') ?? false;
  runApp(MyApp(isViewed: isViewed));
}

class MyApp extends StatelessWidget {
  final bool isViewed;
  const MyApp({super.key, required this.isViewed});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isViewed ? MainPage() : Getstarted(),
    );
  }
}
