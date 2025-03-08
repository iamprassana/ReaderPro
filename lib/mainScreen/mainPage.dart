// ignore_for_file: file_names
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for compute()
import 'package:reader_pro/database/dataBase.dart';
import 'package:reader_pro/gemini/gemini.dart';
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
  final DatabaseService db = DatabaseService.instance;
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
      barrierDismissible: true,
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
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> pickFile(BuildContext context) async {
    FilePickerResult? fp = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );

    if (fp == null) return;

    String? filePath = fp.files.single.path;
    PlatformFile file = fp.files.first;
    String fileName = file.name;
    fileName = fileName.split('.').first.trim();

    if (filePath != null) {
      showLoadingDialog(context);

      try {
        // Extract content from PDF

        final file = await db.getSingleRecord(fileName);

        if (file != null &&
            file.containsKey('name') &&
            file.containsKey('content')) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Displaypage(
                fileName: file['name'],
                content: file['content'],
              ),
            ),
          );
        } else {
          String? content = await compute(extractPDFContent, filePath);
          if (content == null || content.isEmpty) {
            throw Exception("Failed to extract content from the file.");
          }

          // Convert to Bionic format - heavy processing isolated in `compute`
          final geminiString = await compute(geminiConversion, content);
          final bionicFormat = await compute(convertToBionic, geminiString);

          await db.insert(fileName, bionicFormat);

          if (!context.mounted) return;
          Navigator.pop(context); // Close loading dialog

          // Navigate to display page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Displaypage(
                fileName: fileName,
                content: bionicFormat,
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) Navigator.pop(context);
        print("Error extracting or processing file");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to process file")),
        );
      }
    }
  }

  Future<void> _dialogBuilder(BuildContext outerContext) {
    return showDialog<void>(
      context: outerContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('File Opener'),
          content: const Text("Add a File"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.SecondaryColor2)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: const Text('Choose From Device',
                  style: TextStyle(color: AppColors.SecondaryColor2)),
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
        onPressed: () {
          _dialogBuilder(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Library"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

/// Top-level function for compute() - isolates heavy processing
Future<String> convertToBionic(String content) async {
  final gemini = Gemini(); // Create new Gemini instance in isolate
  return await gemini.generateToBionicFormat(content);
}

Future<String> geminiConversion(String content) async {
  final gemini = Gemini();
  return await gemini.generator(content);
}

Future<String?> extractPDFContent(String filePath) {
  final extractor = Extractor();
  return extractor.extractPDF(filePath);
}
