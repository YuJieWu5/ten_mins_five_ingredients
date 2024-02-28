import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/global_state.dart';
import '../Ingredient/ingredients_list.dart';
import 'camera_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PhotoCapturePage extends StatelessWidget {
  const PhotoCapturePage({super.key});

  Future getIngredientListFromOpenAI(
      String imageBase64, BuildContext context) async {
    var list = await sendImageToOpenAI(imageBase64);
    print(list);
    context.read<GlobalState>().loading = false;
  }

  List<String> parseIngredients(String response) {
    // This regex looks for patterns with numbers followed by '.', captures the text that follows until the line break
    RegExp exp = RegExp(r'\d+\.\s*([^\n]+)');
    Iterable<RegExpMatch> matches = exp.allMatches(response);

    // Map matches to their group(1) which captures the ingredient's name, trimming any leading or trailing whitespace
    List<String> ingredients = matches.map((m) => m.group(1)!.trim()).toList();

    return ingredients;
  }

  Future<List<String>> sendImageToOpenAI(String base64Image) async {
    // TODO: make API key a return value from server
    final headers = {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer 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",
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
              "text":
                  "Please list all the food ingredients in this image, I only need the name, list them as bullet points with 1., 2. or 3."
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

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String assistantMessage =
            jsonResponse['choices'][0]['message']['content'];
        print("Response from OpenAI: ${assistantMessage}");
        return parseIngredients(assistantMessage);
      } else {
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
            context.watch<GlobalState>().loading
                ? const Expanded(child: CircularProgressIndicator())
                : AspectRatio(
                    aspectRatio: 3 / 4, // Square box
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: const CameraWidget(),
                    ),
                  ),
            ActionBar(getIngredientListFromOpenAI: getIngredientListFromOpenAI),
            // Confirm to use the photo
          ],
        ),
      ),
    );
  }
}

class ActionBar extends StatelessWidget {
  const ActionBar({required this.getIngredientListFromOpenAI, super.key});

  final Function(String, BuildContext) getIngredientListFromOpenAI;

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
      context.read<GlobalState>().loading = true;
      String base64String = base64Encode(await file.readAsBytes());
      getIngredientListFromOpenAI(base64String, context);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      context.read<GlobalState>().loading = true;
      String base64String = base64Encode(await pickedFile.readAsBytes());
      getIngredientListFromOpenAI(base64String, context);
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
              onPressed: () => getImage(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () async {

              },
            ),
          ),
        ],
      ),
    );
  }
}
