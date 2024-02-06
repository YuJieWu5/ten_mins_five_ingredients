import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ten_mins_five_ingredients/recipe_detail.dart';


void main() {
  testWidgets('Recipe_detail test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MaterialApp(
      home: RecipeDetail(),
    ));

    // Verify that our counter starts at 0.
    expect(find.byType(RecipeDetail), findsOneWidget);
    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Instruction'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);

  });
}
