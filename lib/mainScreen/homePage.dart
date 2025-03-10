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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    didChangeDependencies();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when returning to this screen
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final data = await db.getAllRecord();

    // Only update state if the widget is still mounted
    if (mounted) {
      setState(() {
        records = data;
        isLoading = false;
      });
    }
  }

  Widget displayTile() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (records == null || records!.isEmpty) {
      return Center(
        child: Text(
          records == null ? "No records found" : "No data available",
          style: const TextStyle(
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
                  content: records![index]['content'],
                ),
              ),
            );
            setState(() {
              fetchData();
            });// Refresh data when returning from detail page
          },
          child: Card(
            color: Colors.amber,
            elevation: 2.0,
            shadowColor: AppColors.PrimaryColor2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              //Deletes the current file stored in the database.
              trailing: IconButton(onPressed: () {
                db.delete(records![index]['name']);
                setState(() {
                  fetchData();
                });
              }, icon: Icon(Icons.delete)),
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
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: displayTile(),
      ),
    );
  }
}
