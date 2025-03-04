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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isClicked ? kToolbarHeight : 0),
        child: AnimatedOpacity(
          opacity: isClicked ? 1.0 : 0.0,
          curve: Curves.easeOut,
          duration: Duration(milliseconds: 1000),
          // height: isClicked ? kToolbarHeight * 3 : 0.0,
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
      //Display no app bar
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
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.normal),
              padding: EdgeInsets.all(15),
              scrollDirection: Axis.vertical,
              child: Expanded(
                child: Text(
                  widget.content,
                  style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
        ),
      ), //Change the functionalities to make it good for reading. Scrollable...
    );
  }
}
