import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/recipe_list_page.dart';
import 'package:ten_mins_five_ingredients/views/Home/recipe_detail.dart';

main(){
  testWidgets("Test recipe list page ui and navigation", (WidgetTester tester) async {
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

    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => RecipeList(),
        ),
        GoRoute(
          path: '/recipeDetail',
          builder: (BuildContext context, GoRouterState state) => RecipeDetail(recipe: recipe),
        )
      ],
    );
    await tester.pumpWidget(
        MaterialApp.router(
            routerConfig: router
        )
    );
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsAny);
    expect(find.byType(IconButton), findsAny);

    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();


    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Instruction'), findsOneWidget);
  });
}