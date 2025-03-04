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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fileName,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 26),
          textAlign: TextAlign.justify,
        ),
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.PrimaryColor1,
      ),
      backgroundColor: AppColors.PrimaryColor2,
      body: Text(widget
          .content), //Change the functionalities to make it good for reading. Scrollable...
    );
  }
}
