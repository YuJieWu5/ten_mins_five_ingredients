import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ten_mins_five_ingredients/main.dart';
import 'package:ten_mins_five_ingredients/log_in.dart';

void main() {
  testWidgets('Login_page test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.login));
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsOneWidget);

    expect(find.byType(LogInPage), findsOneWidget);
  });
}