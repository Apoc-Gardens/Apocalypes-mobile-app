import 'package:flutter/material.dart';
import '../models/test_table.dart';
import '../services/database_service.dart';

class dbpage extends StatefulWidget {
  const dbpage({super.key});

  @override
  State<dbpage> createState() => _dbpageState();
}
15
class _dbpageState extends State<dbpage> {
  int count = 0;
  @override
  void initState() {
    super.initState();
    updateCount();
  }

  List<List<String>> data = [];
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<void> updateCount() async {
    count = (await databaseHelper.getMax())!;
    count++;
  }

  Future<void> inserttest() async {
      int response = await databaseHelper.insertTestData(count, "name $count", "description $count");
      count++;
      print("db response");
      print(response);
  }

  Future<void> readtest() async {
    List<TestTable> testTables = await databaseHelper.getAllTestTables();
    for (var testTable in testTables) {
      print('ID: ${testTable.id}, Name: ${testTable.name}, Description: ${testTable.description}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
                inserttest();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
              ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
            ),
            child: const Text('Insert',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              readtest();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
              ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
            ),
            child: const Text('Read',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        ],
      ),
    );
  }
}
