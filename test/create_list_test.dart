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
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/save_list.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  testWidgets('save list test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    Map<String, dynamic> mock_recipes = {
      "-NrhK-N-i3cg1XRGBZ-K": {
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
        "title": "Recipe 1"
      },
      "-NrhK-N-i3cg1XRGBZ-Q": {
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
        "title": "Recipe 2"
      },
      "-NrhK-N-i3cg1XRGBZ-W": {
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
        "title": "Recipe 3"
      }
    };
    MockFirebaseDatabase.instance.ref().child('recipes').set(mock_recipes);
    final storage = MockFirebaseStorage();
    final storageRef = storage.ref().child('Simply-Recipes-Bruschetta-Tomato-Basil-LEAD-3-772fd11de4144552a485af87f7033bf8.jpeg');
    final localImage = await rootBundle.load("assets/images/omelet.jpg");
    final task = await storageRef.putData(localImage.buffer.asUint8List());
    final globalState = GlobalState(false, storage,
        MockFirebaseDatabase.instance, MockFirebaseAuth());
    globalState.setSaveList(["-NrhK-N-i3cg1XRGBZ-K", "-NrhK-N-i3cg1XRGBZ-W"]);

    await mockNetworkImages(() async => await tester.pumpWidget(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => globalState),
            ],
            child: MaterialApp(
              home: SaveList(test: true,),
            )))
            );
    await tester.pumpAndSettle();
    expect(find.byType(SaveList), findsOneWidget);
    expect(find.text('Recipe 1'), findsOneWidget);
    expect(find.text('Recipe 3'), findsOneWidget);
  });
}
