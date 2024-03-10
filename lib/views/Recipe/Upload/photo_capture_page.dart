import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/core/models/ingredient_state.dart';
import 'package:ten_mins_five_ingredients/core/models/ingredients.dart';
import 'camera_widget.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class PhotoCapturePage extends StatelessWidget {
  const PhotoCapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a Photo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView for scrolling
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            AspectRatio(
                    aspectRatio: 3 / 4, // Square box
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: const CameraWidget(),
                    ),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ActionBar(),
            )
            // Confirm to use the photo
          ],
        ),
      ),
    );
  }
}

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  Future takePicture(BuildContext context) async {
    CameraController controller =
        context.read<GlobalState>().getCameraController()!;
    if (!controller!.value.isInitialized) {
      return null;
    }
    if (controller!.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await controller!.takePicture();
      String base64String = base64Encode(await file.readAsBytes());
      context.read<IngredientState>().getIngredientListFromOpenAI(base64String);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String base64String = base64Encode(await pickedFile.readAsBytes());
      context.read<IngredientState>().getIngredientListFromOpenAI(base64String);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: const Text('Select from gallery'),
              onPressed: () async => await getImage(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () async => await takePicture(context),
            ),
          ),
        ],
      ),
    );
  }
}
