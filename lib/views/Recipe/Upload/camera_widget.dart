import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:ten_mins_five_ingredients/core/models/global_state.dart';

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
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    initializeCamera();
  }

  Future<void> initializeCamera() async {
    await initializeCameras();
    if (cameras.isEmpty) {
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
      final globalState = context.read<GlobalState>();
      globalState.setCameraController(controller);
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
        child: CameraPreview(controller!));
  }
}
