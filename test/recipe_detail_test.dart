import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';
import 'package:ten_mins_five_ingredients/views/Home/recipe_detail.dart';


void main() {
  testWidgets('Recipe_detail test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    Map<String, dynamic> mock_recipe = {
      "id": "-NrhK-N-i3cg1XRGBZ-K",
      "creator": "qktJ4LO3LRLZdHWg271z",
      "image": "Simply-Recipes-Bruschetta-Tomato-Basil-LEAD-3-772fd11de4144552a485af87f7033bf8.jpeg",
      "ingredient": [
        "tomato 50g",
        "fresh basil 5g",
        "garlic 10g",
        "baguette slices 4 pieces"
      ],
      "instruction": [
        "Combine diced tomatoes, fresh basil, garlic, olive oil, balsamic vinegar, salt and pepper",
        "Then spoon the misture onto toasted baguette slices"
      ],
      "rating": 3.5,
      "rating-count": 2,
      "title": "Tomato Basil Bruschetta"
    };

    final Recipe recipe = Recipe.fromJson(mock_recipe);
    await tester.pumpWidget(MaterialApp(
      home: RecipeDetail(recipe: recipe),
    ));

    // Verify that our counter starts at 0.
    expect(find.byType(RecipeDetail), findsOneWidget);
    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Instruction'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);

  });
}
