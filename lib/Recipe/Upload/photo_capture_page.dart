import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/global_state.dart';
import '../../ingredients_list.dart';
import 'camera_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
            const ActionBar(), // Confirm to use the photo
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
      await sendImageToOpenAI(base64String);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String base64String = base64Encode(await pickedFile.readAsBytes());
      var list = await sendImageToOpenAI(base64String);
      print(list);
    }
  }

  List<String> parseIngredients(String response) {
    // This regex looks for patterns with numbers followed by '.', and captures the text following it until a newline or the end of the string
    RegExp exp = RegExp(r'\d+\.\s*([^\n]+)');
    // Use RegExp to find matches within the response
    Iterable<RegExpMatch> matches = exp.allMatches(response);

    // Map matches to their group(1) which is the actual text of the ingredient, trimming any leading or trailing whitespace
    List<String> ingredients = matches.map((m) => m.group(1)!.trim()).toList();

    return ingredients;
  }

  Future<List<String>> sendImageToOpenAI(String base64Image) async {
    // TODO: make API key a return value from server
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ",
    };

    // Payload setup
    final payload = jsonEncode({
      "model": "gpt-4-vision-preview",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": "Please list all the food ingredients in this image, list them as bullet points with 1., 2. or 3."
            },
            {
              "type": "image_url",
              "image_url": {
                "url": "data:image/jpeg;base64,$base64Image",
              }
            }
          ]
        }
      ],
      "max_tokens": 300,
    });

    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: headers,
        body: payload,
      );

      // Handling the response
      if (response.statusCode == 200) {
        // Successfully received a response
        print("Response from OpenAI: ${response.body}");
        return parseIngredients(response.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print("Failed to load data: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error sending image to OpenAI: $e");
      return [];
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
              child: const Text('Select form gallery'),
              onPressed: getImage,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await takePicture(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IngredientListPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
