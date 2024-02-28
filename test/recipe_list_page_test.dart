import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/recipe_list_page.dart';
import 'package:ten_mins_five_ingredients/views/Home/recipe_detail.dart';

main(){
  testWidgets("Test recipe list page ui and navigation", (WidgetTester tester) async {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => RecipeList(),
        ),
        GoRoute(
          path: '/recipeDetail',
          builder: (BuildContext context, GoRouterState state) => RecipeDetail(),
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