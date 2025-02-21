// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:reader_pro/mainScreen/homePage.dart';
import 'package:reader_pro/mainScreen/library.dart';
import 'package:reader_pro/mainScreen/settings.dart';
import 'package:reader_pro/utils/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomepageState();
}

//Show recently read books in the home page. When floating action button is clicked give a promopt to import a book. Once the book is opened then redirect them to different page. Meanwhile show CiruclarProgressIndicator.

class _HomepageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    Homepage(),
    Library(),
    Settings(),
  ];

  void _onItemTapped(int currentIndex) {
    setState(() {
      _selectedIndex = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.PrimaryColor1,
        elevation: 1,
        shadowColor: AppColors.PrimaryColor2,
        title: Text(
          "Reader Pro",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Implement the other add feature.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Clicked"),
              duration: Duration(milliseconds: 500),
            ),
          );
          //Add an book i.e import an book to the app.
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: AppColors.SecondaryColor2,
        foregroundColor: AppColors.PrimaryColor2,
        child: Icon(Icons.add),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.PrimaryColor1,
        elevation: 10,
        selectedItemColor: AppColors.SecondaryColor2,
        enableFeedback: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: (Icon(Icons.home)),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: (Icon(Icons.book)),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: (Icon(Icons.settings)),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
