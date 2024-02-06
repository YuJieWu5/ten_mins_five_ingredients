import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ten_mins_five_ingredients/camera_widget.dart';
import 'package:ten_mins_five_ingredients/photo_capture_page.dart';


void main() {
  testWidgets('Photo_capture test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MaterialApp(
      home: PhotoCapturePage(),
    ));

    // Verify that our counter starts at 0.
    expect(find.byType(CameraWidget), findsOneWidget);
    expect(find.text('Retake'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
  });
}