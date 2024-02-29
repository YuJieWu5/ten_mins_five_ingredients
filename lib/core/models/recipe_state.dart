import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';
import 'dart:convert';
import '../../routes/app_routes.dart';
import './ingredients.dart';
import './global_state.dart';


class RecipeState with ChangeNotifier {

  List<Recipe> _recipeList = [];
  List<Recipe> get recipeList => _recipeList;

  set recipeList(List<Recipe> newRecipeList) {
    _recipeList = newRecipeList;
    notifyListeners();
  }

  List<Recipe> parseRecipes(String response) {
    List<String> recipeSections = response.split('=========\n');
    print(recipeSections);
    List<Recipe> recipes = [];

    for (var section in recipeSections) {
      final titleMatch = RegExp(r'title: (.*)').firstMatch(section);
      final descriptionMatch = RegExp(r'description: (.*)').firstMatch(section);
      final ingredientsMatch = RegExp(r'ingredients: (.*)').firstMatch(section);
      final stepsMatch = RegExp(r'steps: (.*)').firstMatch(section);

      if (titleMatch != null && descriptionMatch != null && ingredientsMatch != null && stepsMatch != null) {
        List<String> ingredients = ingredientsMatch.group(1)!
            .split(', ')
            .where((i) => i.isNotEmpty)
            .toList();
        List<String> steps = stepsMatch.group(1)!
            .split('. ')
            .where((i) => i.isNotEmpty)
            .toList();

        Recipe recipe = Recipe(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: titleMatch.group(1)!,
          description: descriptionMatch.group(1)!,
          ingredients: ingredients,
          steps: steps,
          imageUrl: 'https://placehold.co/600x400/png',
          rating: 5.0,
          ratingCount: 10
        );

        recipes.add(recipe);
      }
    }

    print(recipes);
    return recipes;
  }


  Future getRecipesFromOpenAI(List<Ingredient> ingredients) async {
    router.push('/loading');
    // TODO: make API key a return value from server
    final headers = {
      "Content-Type": "application/json",
      "Authorization":
      "Bearer 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",
    };

    // Payload setup
    final payload = jsonEncode({
      "model": "gpt-4-turbo-preview",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text":
              """Given the ingredients: ${ingredients.map((e) => e.name).join(",")}, choose at most 5 of them and generate 3 detailed recipes that include the following information for each recipe: 
            Name each recipe with a separate line called "recipe1:", "recipe2:", "recipe3:", and separate them by a line "========="
            1. A recipe title, called "title"
            2. A short description, called "description"
            3. A formatted list of ingredients used (formatted as: "1. eggs, 2. flour, 3. sugar."), called "ingredients"
            4. A sequence of steps for the preparation (formatted as: "1. Mix eggs and sugar together, 2. Gradually add flour, etc."), called "steps"
            Please use plain text, don't use bullet points, don't use any bold or other rich text decorators.
            Please ensure that the ingredients and steps are clearly numbered and separated to allow for easy parsing in the application.
            """
            }
          ]
        }
      ],
      "max_tokens": 4096,
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
        recipeList = parseRecipes(assistantMessage);
        router.push('/getRecipeList');
      } else {
        print("Failed to load data: ${response.body}");
      }
    } catch (e) {
      print("Error sending image to OpenAI: $e");
    }
  }
}