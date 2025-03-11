import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:reader_pro/database/dataBase.dart';
import 'package:reader_pro/utils/colors.dart';

class Displaypage extends StatefulWidget {
  final String fileName;
  final String content;

  const Displaypage({
    super.key,
    required this.fileName,
    required this.content,
  });

  @override
  State<Displaypage> createState() => _DisplaypageState();
}

class _DisplaypageState extends State<Displaypage> {
  final DatabaseService db = DatabaseService.instance;
  bool isClicked = true;
  bool isVoiceActivated = false;
  final FlutterTts _flutterTts = FlutterTts();
  Map? _currentVoice;

  void changeAppBar() {
    setState(() {
      isClicked = !isClicked;
    });
  }

  List<TextSpan> parseBionicText(String input) {
    final regex = RegExp(r'\*\*(.+?)\*\*');
    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final match in regex.allMatches(input)) {
      // Regular text before bold part
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: input.substring(currentIndex, match.start),
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              color: AppColors.SecondaryColor2),
        ));
      }

      // Bold text inside ** **
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          color: AppColors.SecondaryColor2,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          fontSize: 17,
        ),
      ));

      // Move to the next part
      currentIndex = match.end;
    }

    // Regular text after the last bold section
    if (currentIndex < input.length) {
      spans.add(TextSpan(
        text: input.substring(currentIndex),
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            color: AppColors.SecondaryColor2),
      ));
    }

    return spans;
  }

  String getPlainText(String input) {
    final regex = RegExp(r'\*\*(.+?)\*\*');
    return input.replaceAllMapped(regex, (match) => match.group(1)!);
  }

  @override
  void dispose() {
    print("Cancelling text to speech");
    _flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initTts();
  }

  void initTts() {
    _flutterTts.getVoices.then(
      (data) {
        try {
          List<Map> _voices = List<Map>.from(data);
          _voices =
              _voices.where((_voice) => _voice["name"].contains("en")).toList();

          setState(() {
            _currentVoice = _voices.first;
            setVoice(_currentVoice!);
          });
        } catch (e) {
          print(e);
        }
      },
    );
  }

  String extractPlainText(String content) {
    final regex = RegExp(r'\*\*(.+?)\*\*');
    return content.replaceAllMapped(regex, (match) => match.group(1)!);
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  void speak(bool speak, String content) async {
    if (speak) {
      String _content = getPlainText(content);
      _flutterTts.speak(_content);
    } else {
      _flutterTts.pause();
    }
  }

  String _selectedOption = "More";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.PrimaryColor1,
        onPressed: () {
          RenderBox button = context.findRenderObject() as RenderBox;
          Offset position = button.localToGlobal(Offset.zero); // Get FAB position
          double left = position.dx + 280;
          double top = position.dy + 575; // Adjust to show menu above FAB

          showMenu(
            context: context,
            color: AppColors.PrimaryColor1, // Background color of menu
            position: RelativeRect.fromLTRB(left, top, left + 50, top + 50),
            items: [
              PopupMenuItem(
                value: "Mic",
                child: ListTile(
                  leading: Icon(Icons.mic, color: AppColors.textDefault),
                  title: Text("Mic", style: TextStyle(color: AppColors.textDefault)),
                ),
              ),
              PopupMenuItem(
                value: "Quiz",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Coming Soon")),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.quiz, color: AppColors.textDefault),
                  title: Text("Quiz", style: TextStyle(color: AppColors.textDefault)),
                ),
              ),
              PopupMenuItem(
                value: "Timer",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Coming Soon")),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.timer, color: AppColors.textDefault),
                  title: Text("Timer", style: TextStyle(color: AppColors.textDefault)),
                ),
              ),
            ],
          ).then((value) {
            if (value == "Mic") {
              speak(true, widget.content);
            } else {
              _flutterTts.pause();
            }
          });
        },
        child: Icon(Icons.more_vert, color: Colors.white),
      ),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isClicked ? kToolbarHeight : 0),
        child: AnimatedOpacity(
          opacity: isClicked ? 1.0 : 0.0,
          curve: Curves.easeOut,
          duration: Duration(milliseconds: 1000),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.textDefault,
              ),
            ),
            title: Text(
              widget.fileName,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  color: AppColors.textDefault),
              textAlign: TextAlign.justify,
            ),
            automaticallyImplyLeading: true,
            backgroundColor: AppColors.PrimaryColor1,
          ),
        ),
      ),
      backgroundColor: AppColors.PrimaryColor2,
      body: GestureDetector(
        onTap: () {
          changeAppBar();
        },
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(26),
          panEnabled: false,
          minScale: 1.0,
          maxScale: 5.0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal,
              ),
              scrollDirection: Axis.vertical,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.SecondaryColor2,
                    fontFamily: 'Poppins',
                    fontSize: 17,
                  ),
                  children: parseBionicText(widget.content),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


