// ignore_for_file: file_names
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:reader_pro/mainScreen/displayPage.dart';
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
  Extractor extractor = Extractor();
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

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: AlertDialog(
            backgroundColor: AppColors.PrimaryColor1,
            content: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.SecondaryColor2),
                    strokeWidth: 5.0,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Please Wait While We Load The Content",
                    style: TextStyle(color: AppColors.SecondaryColor2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void pickFile(BuildContext context) async {
    FilePickerResult? fp = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );

    if (fp == null) return;

    String? filePath = fp.files.single.path;
    PlatformFile file = fp.files.first;
    String fileName = file.name;

    if (filePath != null) {
      showLoadingDialog(context);

      try {
        //Have a 2 second time delay
        await Future.delayed(
          Duration(seconds: 2),
        );

        //Extracts the contents of the pdf
        String? content = await extractor.extractPDF(filePath);

        if (!mounted) return;
        //Close Laoding
        Navigator.pop(context);

        if (content != null) {
          //Navigate to display the pdf content
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Displaypage(
                fileName: fileName,
                content: content,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) Navigator.pop(context);
        print("Error extracting file: $e");
      }
    }
  }

  Future<void> _dialogBuilder(BuildContext outerContext) {
    return showDialog<void>(
      context: outerContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Files'),
          content: const Text("Add a File"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: const Text('Choose From Device'),
              onPressed: () async {
                Navigator.pop(dialogContext);
                pickFile(outerContext);
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
        onPressed: () => _dialogBuilder(context),
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
