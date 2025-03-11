// ignore_for_file: file_names
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for compute()
import 'package:google_generative_ai/google_generative_ai.dart';
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
                        Colors.white),
                    strokeWidth: 5.0,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Please Wait While We Load The Content",
                    style: TextStyle(color: AppColors.textDefault),
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
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Displaypage(
                fileName: file['name'],
                content: file['content'],
              ),
            ),
          );
        } else {
          // Replace compute with direct async calls
          print("Extracting text");
          String? content = await compute(extractPDFContent, filePath);
          if (content == null) throw Exception("Failed to extract content");

          String geminiString = await geminiConversion(content);
          print("Got gemini string");

          String bionicFormat = await convertToBionic(geminiString);
          print("Getting bionic format");

          print("Inserting into db");
          await db.insert(fileName, bionicFormat);

          if (!context.mounted) return;
          Navigator.pop(context); // Close loading dialog

          // Navigate to display page
          print("Pushing to display page");
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
        print("Error extracting or processing file ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to process file")),
        );
      }
    }
  }

  // Future<void> pickFile(BuildContext context) async {
  //   await db.database;
  //   FilePickerResult? fp = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'txt'],
  //   );
  //
  //   if (fp == null) return;
  //
  //   String? filePath = fp.files.single.path;
  //   String fileName = fp.files.first.name.split('.').first.trim();
  //
  //   if (filePath != null) {
  //     showLoadingDialog(context);
  //
  //     try {
  //       print("Extracting content...");
  //       String? content = await compute(extractPDFContent, filePath);
  //       if (content == null) throw Exception("Failed to extract content");
  //
  //       print("Calling Gemini conversion...");
  //       final geminiString = await compute(geminiConversion, content);
  //       final bionicFormat = await compute(convertToBionic, geminiString);
  //
  //       Navigator.pop(context);
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) =>
  //               Displaypage(fileName: fileName, content: bionicFormat),
  //         ),
  //       );
  //     } catch (e) {
  //       Navigator.pop(context);
  //       print("Error: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Failed to get content: $e")),
  //       );
  //     }
  //   }
  // }

  Future<void> _dialogBuilder(BuildContext outerContext) {
    return showDialog<void>(
      context: outerContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('File Opener'),
          content: const Text("Add a File"),
          actions: <Widget>[
            TextButton(
              child:  Text('Cancel',
                  style: TextStyle(color: AppColors.SecondaryColor2)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: Text('Choose From Device',
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
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogBuilder(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.PrimaryColor1,
        foregroundColor: AppColors.PrimaryColor2,
        child: const Icon(Icons.add),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 22,
        selectedFontSize: 19,
        unselectedFontSize: 19,
        backgroundColor: AppColors.PrimaryColor1,
        elevation: 10,
        selectedItemColor: Colors.white,
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
  print("Calling bionic conversion");
  final gemini = Gemini();
  final String bionicFormat =
      await gemini.generateToBionicFormat(content) ?? "Failed to process";
  return bionicFormat;
}

Future<String> geminiConversion(String content) async {
  final gemini = Gemini();
  print("Calling gemini conversion");
  final String geminiContent = await gemini.generator(content) ?? "";
  return geminiContent;
}

Future<String?> extractPDFContent(String filePath) async {
  final extractor = Extractor();
  print("Calling extraction on: $filePath");

  try {
    final String? content = await extractor.extractPDF(filePath);
    if (content == null || content.isEmpty) {
      print("Extractor failed: Content is empty or null.");
      return null;
    }
    print("Received content successfully.");
    return content;
  } catch (e, stacktrace) {
    print("Error in extractPDFContent: $e");
    print("Stacktrace: $stacktrace");
    return null;
  }
}
