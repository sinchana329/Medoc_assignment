import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'gallery_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Media Demo")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Camera"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CameraScreen()),
            ),
          ),
          ListTile(
            title: const Text("Gallery"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GalleryScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
