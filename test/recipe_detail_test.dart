import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';
import 'package:ten_mins_five_ingredients/views/Home/recipe_detail.dart';

void main() {
  testWidgets('Recipe_detail test', (WidgetTester tester) async {
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

    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance, MockFirebaseAuth());
    final Recipe recipe = Recipe.fromJson(mock_recipe);
    await mockNetworkImages(() async => await tester.pumpWidget(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => globalState),
            ],
            child: MaterialApp(
              home: RecipeDetail(recipe: recipe),
            ))));

    expect(find.byType(RecipeDetail), findsOneWidget);
    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Instruction'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
  });

  testWidgets('Recipe_detail, add new favorite recipe', (WidgetTester tester) async {
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

    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance, MockFirebaseAuth());
    final Recipe recipe = Recipe.fromJson(mock_recipe);
    
    globalState.setUserId("snKO3odC9XPq78KJM1DeqCAjceG3");
    
    await mockNetworkImages(() async => await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => globalState),
        ],
        child: MaterialApp(
          home: RecipeDetail(recipe: recipe),
        ))));

    await tester.tap(find.byKey(Key("SaveRecipeBtn")));
    await tester.pump();

    expect(globalState.getSaveList()!=null, true);
  });

  testWidgets('Recipe_detail, one of the favorite recipe', (WidgetTester tester) async {
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

    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance, MockFirebaseAuth());
    final Recipe recipe = Recipe.fromJson(mock_recipe);

    globalState.setUserId("snKO3odC9XPq78KJM1DeqCAjceG3");

    await mockNetworkImages(() async => await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => globalState),
        ],
        child: MaterialApp(
          home: RecipeDetail(recipe: recipe),
        ))));

    //Save to list
    await tester.tap(find.byKey(Key("SaveRecipeBtn")));
    await tester.pumpAndSettle();
    //Remove from list
    await tester.tap(find.byKey(Key("SaveRecipeBtn")));
    await tester.pump();

    expect(globalState.getSaveList()!.length==0, true);
  });
}
