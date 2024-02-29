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

class _CameraWidgetState extends State<CameraWidget> with WidgetsBindingObserver {
  CameraController? controller;

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

    controller?.dispose(); // Dispose the existing controller if any

    controller = CameraController(frontCamera, ResolutionPreset.high);
    try {
      await controller!.initialize();
      if (!mounted) return;
      final globalState = context.read<GlobalState>();
      globalState.setCameraController(controller);
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera
      if (controller != null) {
        initializeCamera();
      }
    }
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
