import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Garden',
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 5,),
            const Text('Connect your recevier device to get started',
            style: TextStyle(
                fontFamily: "Inter",
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scan');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
                ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
              ),
              child: const Text('Connect Device',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
