import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/Upload/upload_recipe_page.dart';

main() {
  testWidgets('Test Upload Recipe if valid case', (
      WidgetTester tester) async {
    await tester.pumpWidget(
        const MaterialApp(
            home: Material(child: UploadRecipePage()
            )
        )
    );

    await tester.enterText(find.byKey(const Key('Ingredient1')), "Peanut");
    await tester.pump();
    await tester.enterText(find.byKey(const Key('Quantity1')), "200g");
    await tester.pump();
    await tester.enterText(find.byKey(const Key('Instruction1')), "Toss cooked noodles with a peanut sauce made from peanut butter, soy sauce, sesame oil, and a touch of sriracha.");
    await tester.pump();
    await tester.tap(find.byKey(const Key('Upload')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('Test Upload Recipe dynamic ingredient and instruction textfield', (
      WidgetTester tester) async {
    await tester.pumpWidget(
        const MaterialApp(
            home: Material(child: UploadRecipePage()
            )
        )
    );

    await tester.tap(find.byKey(const Key('addIngredientButton1')));
    await tester.tap(find.byKey(const Key('addInstructionButton1')));
    await tester.pump();

    expect(find.byKey(const Key('Ingredient2')), findsOneWidget);
    expect(find.byKey(const Key('Instruction2')), findsOneWidget);
  });
}