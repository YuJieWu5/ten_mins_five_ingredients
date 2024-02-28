import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ten_mins_five_ingredients/Recipe/Ingredient/ingredients_list.dart';

void main() {
  testWidgets('Ingredient_list test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MaterialApp(
      home: IngredientListPage(ingredients: [],),
    ));

    // Verify that our counter starts at 0.
    expect(find.byType(IngredientListPage), findsOneWidget);
    expect(find.text('Ingredient List'), findsOneWidget);
    expect(find.text('Show me the recipes!'), findsOneWidget);
  });
}
