import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras = [];

Future<void> initializeCameras() async {
  cameras = await availableCameras();
}

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    // Request camera permission
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    // After obtaining permission, initialize the camera
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    await initializeCameras();
    if (cameras.isEmpty) {
      // No available cameras
      print("No cameras are available");
      return;
    }
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    controller = CameraController(frontCamera, ResolutionPreset.high);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((error) {
      print("Error initializing camera: $error");
    });
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
    return AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: CameraPreview(controller!)); // Display the camera preview with correct aspect ratio
  }
}
