import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/recipe_list_page.dart';
import 'package:ten_mins_five_ingredients/views/Home/recipe_detail.dart';

main() {
  testWidgets("Test recipe list page ui and navigation",
      (WidgetTester tester) async {
    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance, MockFirebaseAuth());

    await mockNetworkImages(
        () async => await tester.pumpWidget(MaterialApp(
          home: RecipeList()
        )));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsAny);
    expect(find.byType(IconButton), findsAny);
  });
}
