import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  File? _capturedFile;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.medium);
    await controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _takePhoto() async {
    final image = await controller!.takePicture();
    final dir = await getApplicationDocumentsDirectory();
    final newPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await File(image.path).copy(newPath);
    setState(() => _capturedFile = saved);
    print("Saved at: $newPath");
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Live Camera")),
      body: Column(
        children: [
          Expanded(child: CameraPreview(controller!)), // live preview
          ElevatedButton(onPressed: _takePhoto, child: const Text("Capture Photo")),
          if (_capturedFile != null)
            Image.file(_capturedFile!, height: 200), // show captured photo
        ],
      ),
    );
  }
}
