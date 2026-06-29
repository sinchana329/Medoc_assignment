import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final picker = ImagePicker();
  File? _file;

  Future<void> _pickFromGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _file = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: _pickFromGallery, child: const Text("Pick Image")),
            if (_file != null) Image.file(_file!, height: 200),
          ],
        ),
      ),
    );
  }
}
