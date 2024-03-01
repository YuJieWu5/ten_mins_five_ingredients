import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/ingredient_state.dart';
import 'package:ten_mins_five_ingredients/core/models/ingredients.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/Ingredient/ingredients_list.dart';

void main() {
  testWidgets('Ingredient_list test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    var ingredientState = IngredientState();
    ingredientState.ingredientList = [Ingredient(name: "Apple", emoji: ""), Ingredient(name: "Pear", emoji: "")];
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ingredientState),
        ],
        child: MaterialApp(
          home: IngredientListPage(),
        )));
        
    await tester.pumpAndSettle();
    expect(find.byType(IngredientListPage), findsOneWidget);
    expect(find.text('Ingredient List'), findsOneWidget);
    expect(find.text('Show me the recipes!'), findsOneWidget);
    expect(find.text(' Apple'), findsOneWidget);
    expect(find.text(' Pear'), findsOneWidget);
  });
}
