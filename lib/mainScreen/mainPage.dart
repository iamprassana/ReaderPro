// ignore_for_file: file_names

import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:reader_pro/mainScreen/homePage.dart';
import 'package:reader_pro/mainScreen/library.dart';
import 'package:reader_pro/mainScreen/settings.dart';
import 'package:reader_pro/utils/colors.dart';
import 'package:reader_pro/utils/filePicker.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomepageState();
}

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

  void pickFile() async {
    FilePickerResult? fp = await FilePicker.platform.pickFiles(
        //allowedExtensions: ['jpg', 'pdf', 'txt']
        );

    if (fp == null) {
      print("No Type of file found");
    }

    PlatformFile? file = fp!.files.first;
    viewFile(file);
  }

  void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Files'),
          content: const Text("Add a File"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(),
              ),
              onPressed: () {
                print("Clicked");
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Choose From Device'),
              onPressed: () async {
                pickFile();
                //Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.PrimaryColor1,
        elevation: 1,
        shadowColor: AppColors.PrimaryColor2,
        title: const Text(
          "Reader Pro",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogBuilder(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: AppColors.SecondaryColor2,
        foregroundColor: AppColors.PrimaryColor2,
        child: const Icon(Icons.add),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.PrimaryColor1,
        elevation: 10,
        selectedItemColor: AppColors.SecondaryColor2,
        enableFeedback: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
