import 'package:flutter/material.dart';
import 'package:reader_pro/mainScreen/settingScreen/appearnace.dart';

import '../utils/colors.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Themes(),
              //   ),
              // );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Coming soon..."),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Card(
              color: AppColors.SecondaryColor1,
              margin: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.palette_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Appearance",
                    style: TextStyle(
                        color: AppColors.textDefault,
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
