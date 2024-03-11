import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe_state.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/Ingredient/get_recipe_list.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/create_list.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  testWidgets('get recipe list test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    Map<String, dynamic> mock_recipe = {
      "id": "-NrhK-N-i3cg1XRGBZ-K",
      "creator": "qktJ4LO3LRLZdHWg271z",
      "image":
          "Simply-Recipes-Bruschetta-Tomato-Basil-LEAD-3-772fd11de4144552a485af87f7033bf8.jpeg",
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
    final storage = MockFirebaseStorage();
    final recipeState = RecipeState();
    recipeState.recipeList = [recipe];
    await mockNetworkImages(() async => await tester.pumpWidget(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => recipeState),
            ],
            child: MaterialApp(
              home: GetRecipeList(),
            )))
            );
    await tester.pumpAndSettle();
    expect(find.byType(GetRecipeList), findsOneWidget);
    expect(find.text('Tomato Basil Bruschetta'), findsOneWidget);
  });
}
