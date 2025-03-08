import 'package:flutter/material.dart';
import 'package:reader_pro/database/dataBase.dart';
import 'package:reader_pro/mainScreen/displayPage.dart';
import 'package:reader_pro/utils/colors.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseService db = DatabaseService.instance;
  List<Map<String, dynamic>>? records;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await db.getAllRecord();
    setState(() {
      records = data;
    });
  }

  Widget displayTile() {
    if (records == null || records!.isEmpty) {
      return Center(
        child: Text(
          records == null ? "No records found" : "No data available",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: records!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Displaypage(
                    fileName: records![index]['name'],
                    content: records![index]['content']),
              ),
            );
          },
          child: Card(
            color: Colors.amber,
            elevation: 2.0,
            shadowColor: AppColors.PrimaryColor2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              title: Text(
                records![index]['name'],
                style: TextStyle(
                  color: AppColors.SecondaryColor2,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: displayTile(),
      ),
    );
  }
}
