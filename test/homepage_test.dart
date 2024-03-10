import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ten_mins_five_ingredients/views/Home/homepage.dart';
import 'package:ten_mins_five_ingredients/main.dart';


void main() {
  testWidgets('Homepage test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MyApp(storage: MockFirebaseStorage(), database: MockFirebaseDatabase.instance,));

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Get Recipe'), findsOneWidget);
    expect(find.text('Create Recipe'), findsOneWidget);
    expect(find.byIcon(Icons.login), findsOneWidget);

  });
}
