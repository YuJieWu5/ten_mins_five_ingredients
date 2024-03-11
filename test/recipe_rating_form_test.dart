import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';
import 'package:ten_mins_five_ingredients/views/Home/recipe_rating_form.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

void main() {
  testWidgets("Recipe Rating Form Testing",
  (WidgetTester tester) async {
    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance,
        MockFirebaseAuth());

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

    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => globalState),
        ],
        child: MaterialApp(
          home: RecipeRatingForm(recipe: recipe),
      )));

    // Verify if the UI elements are present
    expect(find.text("Rating"), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(5)); // Assuming 5 rating icons
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}