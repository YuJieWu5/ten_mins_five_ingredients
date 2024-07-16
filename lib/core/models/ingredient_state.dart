import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../routes/app_routes.dart';
import './ingredients.dart';
import './global_state.dart';

class IngredientState with ChangeNotifier {
  List<Ingredient> _ingredientList = [];

  List<Ingredient> get ingredientList => _ingredientList;

  set ingredientList(List<Ingredient> newIngredientList) {
    _ingredientList = newIngredientList;
    notifyListeners();
  }

  Future getIngredientListFromOpenAI(String imageBase64) async {
    router.push('/loading');
    var list = await sendImageToOpenAI(imageBase64);
    print(list);
    ingredientList = list.map((e) => Ingredient(name: e, emoji: "")).toList();
    router.push("/ingredientList");
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
    // final keyObj = await ref.child('openai-key').get();
    final String? apiKey = dotenv.env['OPENAI_API_KEY'];
    print("API KEY: $apiKey");
    if (apiKey!=null) {
      final headers = {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer $apiKey",
      };

      // Payload setup
      final payload = jsonEncode({
        "model": "gpt-4o",
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
    return [];
  }
}
