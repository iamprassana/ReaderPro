import 'package:flutter/material.dart';
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
  bool isClicked = true;

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
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 17),
        ));
      }

      // Bold text inside ** **
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
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
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 17),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isClicked ? kToolbarHeight : 0),
        child: AnimatedOpacity(
          opacity: isClicked ? 1.0 : 0.0,
          curve: Curves.easeOut,
          duration: Duration(milliseconds: 1000),
          child: AppBar(
            title: Text(
              widget.fileName,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 26),
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
                  decelerationRate: ScrollDecelerationRate.normal),
              scrollDirection: Axis.vertical,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
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
