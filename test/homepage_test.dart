import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/views/Home/homepage.dart';
import 'package:ten_mins_five_ingredients/main.dart';
import 'package:ten_mins_five_ingredients/views/Home/homepage_carousel_with_indicator.dart';


void main() {
  testWidgets('Homepage test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MyApp(storage: MockFirebaseStorage(), database: MockFirebaseDatabase.instance, auth: MockFirebaseAuth(),));

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Get Recipe'), findsOneWidget);
    expect(find.text('Create Recipe'), findsOneWidget);
    expect(find.byIcon(Icons.login), findsOneWidget);

  });

  testWidgets('Homepage carousel test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
        Map<String, dynamic> mock_recipes = {
      "-NrhK-N-i3cg1XRGBZ-K": {
        "creator": "test123",
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
        "creator": "test123",
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
    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance, MockFirebaseAuth());
    
    await mockNetworkImages(() async => await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => globalState),
        ],
        child: MaterialApp(
          home: CarouselWithIndicator(test: true,),
        ))));
    await tester.pumpAndSettle();
    expect(find.byType(CarouselWithIndicator), findsOneWidget);

  });
}
