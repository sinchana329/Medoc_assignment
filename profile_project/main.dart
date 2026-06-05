import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileCard(),
    );
  }
}

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Ninja ID Card"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
            ),

            SizedBox(height: 30),

            Divider(color: Colors.grey),

            SizedBox(height: 20),

            Text(
              "NAME",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 5),

            Text(
              "Sinchana",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 25),

            Text(
              "EMAIL",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 5),

            Text(
              "sinchana@gmail.com",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 25),

            Row(
              children: [
                Icon(Icons.phone, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "+91 8431397515",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}